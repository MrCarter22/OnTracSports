//
//  MockData.swift
//  OnTracSports
//
//  Created by user279676 on 10/24/25.
//

import Foundation

struct MockData {
    // Mock statistics based on sport (fallback when API fails)
    static func gameStats(for sport: Sport) -> [GameStatistic] {
        switch sport {
        case .nba:
            return [
                GameStatistic(name: "Field Goals", awayValue: "38/82", homeValue: "42/88"),
                GameStatistic(name: "3-Pointers", awayValue: "12/35", homeValue: "10/30"),
                GameStatistic(name: "Free Throws", awayValue: "10/14", homeValue: "8/12"),
                GameStatistic(name: "Rebounds", awayValue: "42", homeValue: "48"),
                GameStatistic(name: "Assists", awayValue: "24", homeValue: "28"),
                GameStatistic(name: "Turnovers", awayValue: "12", homeValue: "9")
            ]
        case .nfl:
            return [
                GameStatistic(name: "Total Yards", awayValue: "342", homeValue: "389"),
                GameStatistic(name: "Passing Yards", awayValue: "245", homeValue: "278"),
                GameStatistic(name: "Rushing Yards", awayValue: "97", homeValue: "111"),
                GameStatistic(name: "Turnovers", awayValue: "1", homeValue: "2"),
                GameStatistic(name: "Time of Possession", awayValue: "28:15", homeValue: "31:45"),
                GameStatistic(name: "3rd Down Conv.", awayValue: "5/12", homeValue: "7/14")
            ]
        case .mlb:
            return [
                GameStatistic(name: "Hits", awayValue: "8", homeValue: "11"),
                GameStatistic(name: "Runs", awayValue: "3", homeValue: "7"),
                GameStatistic(name: "Errors", awayValue: "1", homeValue: "0"),
                GameStatistic(name: "Doubles", awayValue: "2", homeValue: "3"),
                GameStatistic(name: "Home Runs", awayValue: "1", homeValue: "2"),
                GameStatistic(name: "Strikeouts", awayValue: "8", homeValue: "6")
            ]
        case .nhl:
            return [
                GameStatistic(name: "Shots on Goal", awayValue: "28", homeValue: "32"),
                GameStatistic(name: "Power Play", awayValue: "1/4", homeValue: "0/3"),
                GameStatistic(name: "Penalty Minutes", awayValue: "8", homeValue: "6"),
                GameStatistic(name: "Faceoffs Won", awayValue: "24", homeValue: "29"),
                GameStatistic(name: "Hits", awayValue: "18", homeValue: "22"),
                GameStatistic(name: "Blocked Shots", awayValue: "14", homeValue: "16")
            ]
        }
    }
}

