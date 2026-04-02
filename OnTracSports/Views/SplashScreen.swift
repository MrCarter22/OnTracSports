//
//  SplashScreen.swift
//  OnTracSports
//
//  Created by user279676 on 10/24/25.
//

import SwiftUI

struct SplashScreen: View {
    @State private var animateTitle = false
    @State private var animateBalls = false
    
    var body: some View {
        ZStack {
            AppGradient.background
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // App Title
                Text("On Trac Sports")
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .scaleEffect(animateTitle ? 1 : 0.8)
                    .opacity(animateTitle ? 1 : 0)
                
                // Sports Logo
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                
                Spacer()
                
                // Tagline
                VStack(spacing: 5) {
                    Text("Your daily sports.")
                        .font(.system(size: 20, weight: .medium))
                    Text("Live and on time.")
                        .font(.system(size: 20, weight: .medium))
                }
                .foregroundColor(.white.opacity(0.95))
                .padding(.bottom, 60)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                animateTitle = true
            }
            withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
                animateBalls = true
            }
        }
    }
}

