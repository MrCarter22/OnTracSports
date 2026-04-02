//
//  ContentView.swift
//  OnTracSports
//
//  Created by user279676 on 10/24/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(GamesViewModel.self) var gamesViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            LiveGameView()
                .tabItem {
                    Image(systemName: "sportscourt.fill")
                    Text("Scores")
                }
                .tag(0)
            
            FavoritesView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("My Teams")
                }
                .tag(1)
            
            StandingsView()
                .tabItem {
                    Image(systemName: "list.number")
                    Text("Standings")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(3)
        }
        .tint(Color.customTint)
    }
}
