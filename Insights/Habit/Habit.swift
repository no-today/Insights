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
    var name: String
    var rating: HabitRating
    var sort: Int?
    var describe: String?
    var labels: [String]?
    
    init(name: String, rating: HabitRating, sort: Int? = nil, describe: String? = nil, labels: [String]? = nil) {
        self.name = name
        self.rating = rating
        self.sort = sort
        self.describe = describe
        self.labels = labels
    }
}

enum HabitRating: String, Codable {
    case good = "Good"
    case neutral = "Neutral"
    case bad = "Bad"
}
