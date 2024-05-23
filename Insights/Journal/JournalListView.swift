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
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        JournalEditView(item, saveItem, deleteItem)
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    NavigationLink(destination: JournalEditView(nil, saveItem, deleteItem)) {
                        Button(action: {}) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
            }
        }
    }
    
    private func saveItem(item: Journal) {
        withAnimation {
            modelContext.insert(item)
        }
    }
    
    private func deleteItem(item: Journal) {
        withAnimation {
            modelContext.delete(item)
        }
    }
}



#Preview {
    JournalListView()
        .modelContainer(for: Journal.self, inMemory: true)
}
