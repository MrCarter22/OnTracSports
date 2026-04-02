//
//  SportsPill.swift
//  OnTracSports
//
//  Created by user279676 on 10/24/25.
//

import SwiftUI

struct SportPill: View {
    let sport: Sport
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: sport.icon)
                    .font(.system(size: 24))
                Text(sport.rawValue)
                    .font(.system(size: 11, weight: .semibold))
            }
            .frame(width: 70, height: 70)
            .foregroundColor(isSelected ? .white : .white.opacity(0.7))
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.black.opacity(0.3) : Color.white.opacity(0.2))
            )
        }
    }
}
