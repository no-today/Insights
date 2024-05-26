//
//  HabitLabelSelectorView.swift
//  Insights
//
//  Created by whoog on 2024/5/26.
//

import SwiftUI
import SwiftData

struct HabitTagSelector: View {
    @Environment(\.modelContext) private var modelContext
    
    private let sort: SortDescriptor<Habit> = .init(\.priority, order: .forward)
    @State private var selectedTags: Set<String> = []
    
    var body: some View {
        SectionedQueryView(for: Habit.self, groupBy: \.rating, sort: [sort]) { groups in
            VStack(spacing: 15) {
                ForEach(groups.sorted()) { group in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(group.items) { item in
                                TagButton(tag: item.name,
                                          color: Color(hex: item.rating.color),
                                          isSelected: selectedTags.contains(item.id)) {
                                    if selectedTags.contains(item.id) {
                                        selectedTags.remove(item.id)
                                    } else {
                                        selectedTags.insert(item.id)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            for item in initedHabits {
                modelContext.insert(item)
            }
        }
    }
}

struct TagButton: View {
    let tag: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(tag)
                .padding(10)
                .background(isSelected ? color : Color.clear)
                .foregroundColor(isSelected ? .white : .black)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(color, lineWidth: 2)
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .animation(.easeInOut, value: isSelected)
    }
}

#Preview {
    HabitTagSelector()
        .modelContainer(for: Habit.self, inMemory: true)
}
