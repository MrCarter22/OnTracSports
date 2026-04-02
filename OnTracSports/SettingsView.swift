//
//  SettingsView.swift
//  OnTracSports
//
//  Created by user279676 on 10/24/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(GamesViewModel.self) var gamesViewModel
    @State private var settingsViewModel = SettingsViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppGradient.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        SportSelectionSection()
                        AboutSection(viewModel: settingsViewModel)
                        ActionsSection()
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct SportSelectionSection: View {
    @Environment(GamesViewModel.self) var gamesViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("DEFAULT SPORT")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.gradientText)
                .padding(.horizontal)
            
            Text("This is your default sport when opening the app")
                .font(.system(size: 11))
                .foregroundColor(.gradientText.opacity(0.7))
                .padding(.horizontal)
            
            VStack(spacing: 0) {
                ForEach(Sport.allCases, id: \.self) { sport in
                    SportSelectionRow(
                        sport: sport,
                        isSelected: gamesViewModel.defaultSport == sport  // Use defaultSport
                    ) {
                        gamesViewModel.defaultSport = sport  // Only changes defaultSport
                    }
                    if sport != Sport.allCases.last {
                        Divider()
                            .padding(.leading, 50)
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.1), radius: 3)
            .padding(.horizontal)
        }
    }
}

struct SportSelectionRow: View {
    let sport: Sport
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: sport.icon)
                    .foregroundColor(sport.color)
                    .frame(width: 30)
                Text(sport.rawValue)
                    .foregroundColor(.primary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
    }
}

struct AboutSection: View {
    let viewModel: SettingsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ABOUT")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.gradientText)
                .padding(.horizontal)
            
            VStack(spacing: 0) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text(viewModel.appVersion)
                        .foregroundColor(.secondary)
                }
                .padding()
                
                Divider()
                    .padding(.leading)
                
                HStack {
                    Text("Developer")
                    Spacer()
                    Text(viewModel.developer)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.1), radius: 3)
            .padding(.horizontal)
        }
    }
}

struct ActionsSection: View {
    @Environment(GamesViewModel.self) var gamesViewModel
    @State private var showingAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ACTIONS")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.gradientText)
                .padding(.horizontal)
            
            Button(action: {
                showingAlert = true
            }) {
                HStack {
                    Text("Clear All Favorites")
                        .foregroundColor(.red)
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.1), radius: 3)
            }
            .padding(.horizontal)
            .alert("Clear All Favorites?", isPresented: $showingAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear", role: .destructive) {
                    gamesViewModel.clearAllFavorites()
                }
            } message: {
                Text("This will remove all your favorite teams.")
            }
        }
    }
}
