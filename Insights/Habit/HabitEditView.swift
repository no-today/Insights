//
//  HabitEditView.swift
//  Insights
//
//  Created by whoog on 2024/5/23.
//

import SwiftUI

struct HabitEditView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var habit: Habit
    private(set) var save: (Habit) -> Void
    private(set) var delete: (Habit) -> Void

    init(_ habit: Habit? = nil, _ save: @escaping (Habit) -> Void, _ delete: @escaping (Habit) -> Void) {
        self.habit = habit ?? Habit.initial()
        self.save = save
        self.delete = delete
    }
    
    var body: some View {
        Text("AAA")
    }
}

#Preview {
    HabitEditView(nil, { _ in}, { _ in})
}
