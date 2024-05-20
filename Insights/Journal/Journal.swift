//
//  Journal.swift
//  Insights
//
//  Created by no-today on 2024/5/20.
//

import Foundation
import SwiftData

@Model
final class Journal {
    var timestamp: Date
    var content: String
    
    init(timestamp: Date, content: String) {
        self.timestamp = timestamp
        self.content = content
    }
}
