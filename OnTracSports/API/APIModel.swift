//
//  APIModels.swift
//  OnTracSports
//
//  Created by user279676 on 11/30/25.
//

import Foundation

// MARK: - Scoreboard Response

struct ScoreboardResponse: Codable {
    let events: [APIGame]
}

struct APIGame: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let date: String
    let competitions: [Competition]
    let status: GameStatusInfo
    
    static func == (lhs: APIGame, rhs: APIGame) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var homeTeam: Competitor? {
        competitions.first?.competitors.first { $0.homeAway == "home" }
    }
    
    var awayTeam: Competitor? {
        competitions.first?.competitors.first { $0.homeAway == "away" }
    }
    
    var isLive: Bool { status.type.state == "in" }
    var isFinal: Bool { status.type.state == "post" }
    var isScheduled: Bool { status.type.state == "pre" }
    var displayClock: String { status.displayClock ?? "" }
    var period: Int { status.period ?? 0 }
}

struct Competition: Codable, Hashable {
    let competitors: [Competitor]
    let venue: Venue?
    let broadcasts: [Broadcast]?
    let odds: [Odds]?
}

struct Competitor: Codable, Hashable {
    let id: String
    let team: TeamInfo
    let score: String?
    let homeAway: String
    let winner: Bool?
    let records: [Record]?
    
    var displayScore: String { score ?? "0" }
    var isWinner: Bool { winner ?? false }
}

struct TeamInfo: Codable, Hashable {
    let id: String
    let name: String
    let displayName: String
    let shortDisplayName: String
    let abbreviation: String
    let logo: String?
    let color: String?
    let alternateColor: String?
}

struct GameStatusInfo: Codable, Hashable {
    let type: StatusType
    let displayClock: String?
    let period: Int?
}

struct StatusType: Codable, Hashable {
    let id: String
    let name: String
    let state: String
    let completed: Bool
    let description: String
    let detail: String?
    let shortDetail: String?
}

struct Venue: Codable, Hashable {
    let fullName: String
    let address: Address?
}

struct Address: Codable, Hashable {
    let city: String?
    let state: String?
}

struct Broadcast: Codable, Hashable {
    let market: String
    let names: [String]
}

struct Odds: Codable, Hashable {
    let details: String?
    let overUnder: Double?
}

struct Record: Codable, Hashable {
    let name: String?
    let summary: String?
    let type: String?
}

// Standings Response

struct StandingsResponse: Codable {
    let children: [ConferenceData]?
    let standings: StandingsData?
}

struct ConferenceData: Codable {
    let name: String
    let children: [DivisionData]?
    let standings: StandingsData?
}

struct DivisionData: Codable {
    let name: String
    let standings: StandingsData?
}

struct StandingsData: Codable {
    let entries: [StandingEntry]
}

struct StandingEntry: Codable, Identifiable {
    var id: String { team.id }
    let team: TeamInfo
    let stats: [Stat]
    
    var wins: Int { Int(stats.first { $0.abbreviation == "W" }?.value ?? 0) }
    var losses: Int { Int(stats.first { $0.abbreviation == "L" }?.value ?? 0) }
    var winPercentage: Double { stats.first { $0.abbreviation == "PCT" }?.value ?? 0.0 }
    var gamesBack: String { stats.first { $0.abbreviation == "GB" }?.displayValue ?? "-" }
}

struct Stat: Codable {
    let name: String
    let displayName: String
    let shortDisplayName: String?
    let description: String?
    let abbreviation: String?
    let value: Double
    let displayValue: String
}

// Conference Standings (for UI)

struct ConferenceStandings: Identifiable {
    let id = UUID()
    let name: String
    let entries: [StandingEntry]
}
