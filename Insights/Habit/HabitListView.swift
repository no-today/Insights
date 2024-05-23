//
//  LabelListView.swift
//  Insights
//
//  Created by no-today on 2024/5/23.
//

import SwiftUI
import SwiftData

/// Swift Data @Query: https://ihor.pro/implementing-a-swiftdata-query-view-as-the-most-convenient-way-to-fetch-data-in-swiftui-f69d59348783
///
struct HabitListView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var searchText = ""
    @State private var sort: SortDescriptor<Habit> = .init(\.name, order: .forward)
    
    private func setup() {
        modelContext.insert(Habit(name: "Stayup", rating: .bad))
        modelContext.insert(Habit(name: "Sugar", rating: .bad))
        modelContext.insert(Habit(name: "Alcohol", rating: .bad))
        modelContext.insert(Habit(name: "Junkfood", rating: .bad))
        modelContext.insert(Habit(name: "Indulge", rating: .bad))
        
        modelContext.insert(Habit(name: "Workout", rating: .good))
        modelContext.insert(Habit(name: "Read", rating: .good))
        modelContext.insert(Habit(name: "Practise", rating: .good))
        
        modelContext.insert(Habit(name: "Coffee", rating: .neutral))
    }
    
    private func filter() -> Predicate<Habit> {
        #Predicate<Habit> { habit in
            searchText.isEmpty ? true : habit.name.localizedStandardContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            SectionedQueryView(for: Habit.self, groupBy: \.rating, filter: filter, sort: [sort]) { groups in
                List {
                    ForEach(groups.sorted(by: { a, b in a.key == .good })) { group in
                        let text = Text("\(group.key.rawValue) habits").font(.caption).textCase(.none).foregroundColor(.gray)
                        Section(header: text) {
                            ForEach(group.items) { item in
                                Text(item.name)
                            }
                        }
                    }
                }
                .searchable(text: $searchText)
                .toolbar {
                    ToolbarItem {
                        Button(action: {}) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
            }
        }.onAppear {
            withAnimation {
                setup()
            }
        }
    }
}

#Preview {
    HabitListView()
        .modelContainer(for: Habit.self, inMemory: true)
}
