//
//  OnTracSportsApp.swift
//  OnTracSports
//
//  Created by user279676 on 10/24/25.
//

import SwiftUI

@main
struct OnTracSportsApp: App {
    @State private var gamesViewModel = GamesViewModel()
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environment(gamesViewModel)
                
                if showSplash {
                    SplashScreen()
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .onAppear {
                // Hide splash after 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        showSplash = false
                    }
                }
            }
        }
    }
}
