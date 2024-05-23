//
//  JournalListView.swift
//  Insights
//
//  Created by no-today on 2024/5/20.
//

import SwiftUI
import SwiftData

struct JournalListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Journal]
    
    @State private var showingEditSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    NavigationLink(destination: JournalEditView(action: { item in modelContext.insert(item) })) {
                        Button(action: {
                            showingEditSheet = true
                        }) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
            }
        }
    }
}



#Preview {
    JournalListView()
        .modelContainer(for: Journal.self, inMemory: true)
}
