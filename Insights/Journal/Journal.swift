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
    private(set) var timestamp: Date = Date.now
    var date: Date
    var title: String
    var content: String
    
    init(date: Date, title: String, content: String) {
        self.date = date
        self.title = title
        self.content = content
    }
}
