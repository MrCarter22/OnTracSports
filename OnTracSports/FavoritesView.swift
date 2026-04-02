//
//  FavoritesView.swift
//  OnTracSports
//
//  Created by user279676 on 10/24/25.
//

import SwiftUI

struct FavoritesView: View {
    @Environment(GamesViewModel.self) var viewModel
    @State private var selectedGame: Game?
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppGradient.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        FavoriteTeamsSection()
                        
                        // Today's Games Section
                        if !viewModel.favoriteGames.isEmpty {
                            TodaysGamesSection(selectedGame: $selectedGame)
                        }
                    }
                    .padding(.vertical)
                }
                .refreshable {
                    await viewModel.loadFavoriteGames()
                }
            }
            .navigationTitle("My Teams")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(item: $selectedGame) { game in
                GameDetailView(game: game)
            }
        }
        .task {
            await viewModel.loadFavoriteGames()
        }
    }
}

struct FavoriteTeamsSection: View {
    @Environment(GamesViewModel.self) var viewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("FAVORITE TEAMS")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.gradientText)
                .padding(.horizontal)
            
            if viewModel.favoriteTeams.isEmpty {
                EmptyFavoritesView()
            } else {
                ForEach(Array(viewModel.favoriteTeams).sorted(), id: \.self) { team in
                    FavoriteTeamRow(teamName: team)
                }
            }
        }
    }
}

struct FavoriteTeamRow: View {
    let teamName: String
    @Environment(GamesViewModel.self) var viewModel
    
    var body: some View {
        HStack {
            Text(teamName)
                .font(.system(size: 16, weight: .medium))
            Spacer()
            
            Button {
                viewModel.toggleFavorite(teamName)
            } label: {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 3)
        .padding(.horizontal)
    }
}

struct TodaysGamesSection: View {
    @Environment(GamesViewModel.self) var viewModel
    @Binding var selectedGame: Game?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("TODAY'S GAMES")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gradientText)
                
                if !viewModel.favoriteGames.isEmpty {
                    Text("(\(viewModel.favoriteGames.count))")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.gradientText.opacity(0.7))
                }
            }
            .padding(.horizontal)
            
            ForEach(viewModel.favoriteGames) { game in
                GameCard(game: game)
                    .padding(.horizontal)
                    .onTapGesture {
                        selectedGame = game
                    }
            }
        }
        .padding(.top)
    }
}

struct EmptyFavoritesView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "star.slash")
                .font(.system(size: 50))
                .foregroundColor(.gradientTextSecondary)
            Text("No favorite teams yet")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
            Text("Star teams from the scores page")
                .font(.system(size: 15))
                .foregroundColor(.gradientText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .padding(.horizontal)
    }
}
