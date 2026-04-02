//
//  StandingsView.swift
//  OnTracSports
//
//  Created by user279676 on 10/24/25.
//

import SwiftUI

struct StandingsView: View {
    @Environment(GamesViewModel.self) var viewModel
    @State private var selectedStandingsSport: Sport = .nba  // Local state only
    @State private var selectedConference: Int = 0
    @State private var hasInitialized = false
    
    // Conference names based on sport
    private var conferenceNames: [String] {
        switch selectedStandingsSport {
        case .nba, .nhl: return ["Eastern", "Western"]
        case .nfl: return ["AFC", "NFC"]
        case .mlb: return ["American", "National"]
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Full gradient background
                AppGradient.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Sport Selector - local state only
                    StandingsSportSelector(selectedSport: $selectedStandingsSport)
                        .padding(.top, 8)
                    
                    // Conference Picker
                    ConferencePicker(conferences: conferenceNames, selectedIndex: $selectedConference)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    // Standings Table
                    if viewModel.standingsLoading {
                        LoadingStandingsView()
                    } else if viewModel.conferenceStandings.isEmpty && viewModel.standings.isEmpty {
                        EmptyStandingsView(selectedSport: selectedStandingsSport)
                    } else {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 16) {
                                StandingsTableHeader()
                                
                                // Show standings for selected conference
                                if selectedConference < viewModel.conferenceStandings.count {
                                    let conference = viewModel.conferenceStandings[selectedConference]
                                    StandingsTable(standings: conference.entries)
                                } else if !viewModel.standings.isEmpty {
                                    StandingsTable(standings: viewModel.standings)
                                }
                            }
                            .padding(.vertical)
                        }
                    }
                }
            }
            .navigationTitle("Standings")
            .navigationBarTitleDisplayMode(.large)
        }
        .task {
            // Initialize to default sport on first load
            if !hasInitialized {
                selectedStandingsSport = viewModel.defaultSport
                hasInitialized = true
                await viewModel.loadStandings(for: selectedStandingsSport)
            }
        }
        .onChange(of: selectedStandingsSport) { _, newSport in
            // When pill changes, load standings for that sport
            selectedConference = 0
            Task { await viewModel.loadStandings(for: newSport) }
        }
    }
}

// Conference Picker
struct ConferencePicker: View {
    let conferences: [String]
    @Binding var selectedIndex: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(conferences.indices, id: \.self) { index in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedIndex = index
                    }
                } label: {
                    Text(conferences[index])
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(selectedIndex == index ? .white : .white.opacity(0.6))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(selectedIndex == index ? Color.white.opacity(0.25) : Color.clear)
                }
            }
        }
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
    }
}

struct StandingsSportSelector: View {
    @Binding var selectedSport: Sport  // Local binding only
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(Sport.allCases, id: \.self) { sport in
                SportPill(
                    sport: sport,
                    isSelected: selectedSport == sport
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedSport = sport  // Only changes local state
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
    }
}

// Loading View
struct LoadingStandingsView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
            
            Text("Loading standings...")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxHeight: .infinity)
    }
}

// Empty State
struct EmptyStandingsView: View {
    @Environment(GamesViewModel.self) var viewModel
    let selectedSport: Sport
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 50))
                .foregroundColor(.white.opacity(0.5))
            
            Text("No standings available")
                .font(.headline)
                .foregroundColor(.white)
            
            Button {
                Task { await viewModel.loadStandings(for: selectedSport) }
            } label: {
                Text("Try Again")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(20)
            }
        }
        .frame(maxHeight: .infinity)
    }
}

struct StandingsTableHeader: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("#")
                .frame(width: 28, alignment: .center)
            Text("Team")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 4)
            Text("W")
                .frame(width: 32, alignment: .center)
            Text("L")
                .frame(width: 32, alignment: .center)
            Text("PCT")
                .frame(width: 48, alignment: .center)
            Text("GB")
                .frame(width: 36, alignment: .trailing)
        }
        .font(.system(size: 12, weight: .semibold))
        .foregroundColor(.white.opacity(0.8))
        .padding(.horizontal, 12)
    }
}

struct StandingsTable: View {
    let standings: [StandingEntry]
    @Environment(GamesViewModel.self) var viewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(standings.enumerated()), id: \.element.id) { index, entry in
                StandingsRow(
                    rank: index + 1,
                    entry: entry,
                    isEvenRow: index % 2 == 0,
                    isFavorite: viewModel.isFavorite(entry.team.displayName)
                )
                
                if index < standings.count - 1 {
                    Divider()
                        .background(Color.gray.opacity(0.2))
                }
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
        .padding(.horizontal, 12)
    }
}

struct StandingsRow: View {
    let rank: Int
    let entry: StandingEntry
    let isEvenRow: Bool
    let isFavorite: Bool
    
    // Get short team name
    private var shortTeamName: String {
        if !entry.team.shortDisplayName.isEmpty {
            return entry.team.shortDisplayName
        }
        if !entry.team.name.isEmpty {
            return entry.team.name
        }
        return entry.team.displayName.split(separator: " ").last.map(String.init) ?? entry.team.displayName
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // Rank with Logo
            HStack(spacing: 4) {
                Text("\(rank)")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.secondary)
                    .frame(width: 20, alignment: .center)
                
                // Team Logo
                if let logoURL = entry.team.logo, let url = URL(string: logoURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().aspectRatio(contentMode: .fit)
                        case .failure:
                            TeamInitialsView(abbreviation: entry.team.abbreviation)
                        case .empty:
                            ProgressView().frame(width: 24, height: 24)
                        @unknown default:
                            TeamInitialsView(abbreviation: entry.team.abbreviation)
                        }
                    }
                    .frame(width: 24, height: 24)
                } else {
                    TeamInitialsView(abbreviation: entry.team.abbreviation)
                }
            }
            .frame(width: 52)
            
            // Team Name
            HStack(spacing: 4) {
                Text(shortTeamName)
                    .font(.system(size: 14, weight: .medium))
                    .lineLimit(1)
                
                if isFavorite {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.yellow)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Stats
            Text("\(entry.wins)")
                .font(.system(size: 14, weight: .semibold))
                .frame(width: 32, alignment: .center)
            
            Text("\(entry.losses)")
                .font(.system(size: 14))
                .frame(width: 32, alignment: .center)
            
            Text(formatWinPct(entry.winPercentage))
                .font(.system(size: 13))
                .foregroundColor(.secondary)
                .frame(width: 48, alignment: .center)
            
            Text(entry.gamesBack)
                .font(.system(size: 13))
                .foregroundColor(.secondary)
                .frame(width: 36, alignment: .trailing)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 10)
        .background(isEvenRow ? Color.white : Color.gray.opacity(0.05))
    }
    
    private func formatWinPct(_ pct: Double) -> String {
        if pct == 1.0 { return "1.000" }
        if pct == 0.0 { return ".000" }
        return String(format: ".%03.0f", pct * 1000)
    }
}

// Fallback view when logo fails to load
struct TeamInitialsView: View {
    let abbreviation: String
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.gray.opacity(0.3))
            Text(abbreviation.prefix(2))
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.gray)
        }
        .frame(width: 24, height: 24)
    }
}

// Keep for backwards compatibility
struct StandingRow: Identifiable {
    let id = UUID()
    let rank: Int
    let team: String
    let wins: Int
    let losses: Int
}
