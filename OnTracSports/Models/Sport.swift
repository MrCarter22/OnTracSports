//
//  Sport.swift
//  OnTracSports
//
//  Created by user279676 on 10/24/25.
//

import SwiftUI

enum Sport: String, CaseIterable {
    case nba = "NBA"
    case nfl = "NFL"
    case mlb = "MLB"
    case nhl = "NHL"
    
    var icon: String {
        switch self {
        case .nba: return "basketball.fill"
        case .nfl: return "football.fill"
        case .mlb: return "baseball.fill"
        case .nhl: return "hockey.puck.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .nba: return .orange
        case .nfl: return .brown
        case .mlb: return .red
        case .nhl: return .blue
        }
    }
}
