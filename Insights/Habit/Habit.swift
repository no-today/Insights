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
    
    var id: String { name }
    
    init(name: String, rating: HabitRating, priority: Int = 0) {
        self.name = name
        self.rating = rating
        self.priority = priority
    }
}

enum HabitRating: String, Codable, CaseIterable, Identifiable, Comparable {
    case good = "Good"
    case neutral = "Neutral"
    case bad = "Bad"
    
    var id: String { rawValue }
    
    var priority: Int {
        switch self {
        case .good: return 0
        case .bad: return 1
        case .neutral: return 2
        }
    }
    
    var color: String {
        switch self {
        case .good:
            HabitLevel.goodColors[.low]!
        case .neutral:
            HabitLevel.neutralColor
        case .bad:
            HabitLevel.badColors[.low]!
        }
    }
    
    static func < (lhs: HabitRating, rhs: HabitRating) -> Bool {
        lhs.priority < rhs.priority
    }
}

enum HabitLevel: CaseIterable {
    case low, medium, high
    
    fileprivate static let neutralColor: String = "E0E0E0"
    
    fileprivate static let goodColors: [HabitLevel: String] = [
        .low: "9AE9A8",
        .medium: "39B359",
        .high: "226E39"
    ]
    
    fileprivate static let badColors: [HabitLevel: String] = [
        .low: "FCEE4A",
        .medium: "FFC600",
        .high: "FE9601"
    ]
    
    func color(for rating: HabitRating) -> String {
        switch rating {
        case .good:
            return HabitLevel.goodColors[self]!
        case .neutral:
            return HabitLevel.neutralColor
        case .bad:
            return HabitLevel.badColors[self]!
        }
    }
}

let initedHabits = [
    Habit(name: "Stayup", rating: .bad, priority: 1),
    Habit(name: "Sugar", rating: .bad, priority: 2),
    Habit(name: "Alcohol", rating: .bad, priority: 3),
    Habit(name: "Junkfood", rating: .bad, priority: 4),
    Habit(name: "Indulge", rating: .bad, priority: 5),
    Habit(name: "Workout", rating: .good, priority: 1),
    Habit(name: "Read", rating: .good, priority: 2),
    Habit(name: "Practise", rating: .good, priority: 3),
    Habit(name: "Coffee", rating: .neutral, priority: 1)
]
