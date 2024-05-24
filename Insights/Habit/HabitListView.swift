//
//  LabelListView.swift
//  Insights
//
//  Created by no-today on 2024/5/23.
//

import SwiftUI
import SwiftData

/// Swift Data @Query: https://ihor.pro/implementing-a-swiftdata-query-view-as-the-most-convenient-way-to-fetch-data-in-swiftui-f69d59348783
/// Validation Data: https://medium.com/@mhmtkrnlk/how-to-validate-textfields-in-swiftui-like-a-pro-3dbe368d1570
/// Editing persisten datat: https://developer.apple.com/documentation/swiftdata/adding-and-editing-persistent-data-in-your-app
///
struct HabitListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showingEditSheet = false
    
    @State private var searchText = ""
    @State private var sort: SortDescriptor<Habit> = .init(\.priority, order: .forward)
    
    private func filter() -> Predicate<Habit> {
        #Predicate<Habit> { habit in
            searchText.isEmpty ? true : habit.name.localizedStandardContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            SectionedQueryView(for: Habit.self, groupBy: \.rating, filter: filter, sort: [sort]) { groups in
                List {
                    ForEach(groups.sorted(by: { a, b in a.key.sorted > b.key.sorted })) { group in
                        let text = Text("\(group.key.rawValue) Habits").textCase(.none)
                        Section(header: text) {
                            ForEach(group.items) { item in
                                Text(item.name)
                            }.onDelete {
                                self.deleteItems(offsets: $0, items: group.items)
                            }.onMove { source, destination in
                                self.moveItem(source: source, destination: destination, items: group.items)
                            }
                        }
                    }
                }
                .searchable(text: $searchText)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    
                    ToolbarItem {
                        Button(action: {
                            showingEditSheet = true
                        }) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
            }
            
        }
        .sheet(isPresented: $showingEditSheet) {
            HabitEditView()
        }
    }
    
    private func deleteItems(offsets: IndexSet, items: [Habit]) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
    
    private func saveItem(item: Habit) {
        withAnimation {
            modelContext.insert(item)
        }
    }
    
    private func deleteItem(item: Habit) {
        withAnimation {
            modelContext.delete(item)
        }
    }
    
    private func moveItem(source: IndexSet, destination: Int, items: [Habit]) {
        var updatedItems = items
        updatedItems.move(fromOffsets: source, toOffset: destination)
        
        for (index, item) in updatedItems.enumerated() {
            item.priority = index
        }
    }
}

struct HabitEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    private let habit: Habit?
    
    @State private var name = ""
    @State private var rating = HabitRating.good
    
    private var validateFields: Bool {
        name.isEmpty
    }

    private var editorTitle: String {
        habit == nil ? "Add Habit" : "Edit Habit"
    }
    
    init(_ habit: Habit? = nil) {
        self.habit = habit
    }
    
    private func copyof() {
        if let habit {
            name = habit.name
            rating = habit.rating
        }
    }
    
    private func save() {
        if let habit {
            // will auto update
            habit.name = name
            habit.rating = rating
        } else {
            modelContext.insert(Habit(name: name, rating: rating))
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Habit Details").textCase(.none)) {
                    TextField("Habit Name", text: $name)

                    Picker("Rating", selection: $rating) {
                        ForEach(HabitRating.allCases) { item in
                            Text(item.rawValue).tag(item)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
                
                ToolbarItem {
                    Button("Done") {
                        withAnimation {
                            save()
                            dismiss()
                        }
                    }
                    .disabled(validateFields)
                }
            }
            .navigationTitle(editorTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.medium])
        .presentationBackgroundInteraction(.disabled)
        .presentationBackground(.regularMaterial)
    }
}

#Preview {
    HabitListView()
        .modelContainer(for: Habit.self, inMemory: true)
}
