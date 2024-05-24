//
//  Label.swift
//  Insights
//
//  Created by no-today on 2024/5/23.
//

import Foundation
import SwiftData

@Model
final class Habit: Identifiable {
    var timestamp = Date.now
    
    @Attribute(.unique)
    var name: String
    var rating: HabitRating
    var priority: Int
    
    init(name: String, rating: HabitRating, priority: Int = 0) {
        self.name = name
        self.rating = rating
        self.priority = priority
    }
}

enum HabitRating: String, Codable, CaseIterable, Identifiable {
    case good = "Good"
    case neutral = "Neutral"
    case bad = "Bad"
    
    var id: String { self.rawValue }
    
    var sorted: Int {
        switch self {
        case .good: return 1
        case .bad: return -1
        case .neutral: return 0
        }
    }
}
