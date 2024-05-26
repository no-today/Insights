//
//  JournalEditView.swift
//  Insights
//
//  Created by whoog on 2024/5/20.
//

import SwiftUI

struct JournalEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject private var keyboardResponder = KeyboardResponder()
    
    @State private var showingDateSheet = false
    @State private var selectedButton: ButtonType? = nil {
        didSet {
            showingFetureSheet = selectedButton != nil
        }
    }
    @State private var showingFetureSheet = false
    
    private let journal: Journal?
    
    @State private var timestamp = Date.now
    @State private var content = ""
    @State private var date = Date.now
    
    private var validateFields: Bool {
        content.isEmpty
    }
    
    init(_ journal: Journal? = nil) {
        self.journal = journal
    }
    
    private func copyof() {
        if let journal {
            self.timestamp = journal.timestamp
            self.content = journal.content
            self.date = journal.date
        }
    }
    
    private func save() {
        if let journal {
            journal.date = date
            journal.content = content
        } else {
            modelContext.insert(Journal(date: date, title: date.formatted(date: .complete, time: .omitted), content: content))
        }
    }
    
    private func delete() {
        if let journal {
            modelContext.delete(journal)
        }
    }
    
    enum ButtonType: String, CaseIterable {
        case prompt = "fireworks"
        case photo = "photo"
        case location = "location"
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TextEditor(text: $content)
                    .focusable(true)
                    .onTapGesture {
                        selectedButton = nil
                    }
                
                VStack {
                    HStack {
                        ForEach(ButtonType.allCases, id: \.rawValue) { bt in
                            Spacer()
                            Button(action: {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                
                                selectedButton = bt
                            }, label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 11, style: .continuous)
                                        .foregroundColor(.gray.opacity(0.3))
                                        .frame(width: 35, height: 35) // Adjust size to fit the icon
                                        .foregroundStyle(.tint)
                                        .shadow(radius: 3)
                                        .opacity(selectedButton == bt ? 1 : 0)
                                    
                                    Image(systemName: bt.rawValue)
                                        .foregroundStyle(.blue)
                                        .frame(width: 40, height: 40) // Ensure icon is centered in the background
                                }
                            })
                        }
                        Spacer()
                    }
                    Spacer()
                }
                .frame(height: 50 + 200)
                .background(Color(hex: "F5F5F5"))
            }
            .navigationBarBackButtonHidden()
            .navigationTitle(date.formatted(date: .numeric, time: .omitted))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
                
                ToolbarTitleMenu {
                    Section {
                        Button(action: {
                            date = timestamp
                        }, label: {
                            Text("Journal Date")
                            Text(timestamp.formatted(date: .complete, time: .omitted))
                        })
                        
                        Button(action: {
                            showingDateSheet = true
                        }, label: {
                            Label("Custom Date", systemImage: "calendar")
                        })
                    }
                    
                    Button(role: .destructive, action: {
                        withAnimation {
                            delete()
                            dismiss()
                        }
                    }, label: {
                        Label("Delete", systemImage: "trash")
                    })
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
            .presentationDetents([.large])
            .presentationBackgroundInteraction(.automatic)
            .presentationBackground(.regularMaterial)
            .sheet(isPresented: $showingDateSheet) {
                DatePickerView(date: $date, showingDateSheet: $showingDateSheet)
            }
            .sheet(isPresented: $showingFetureSheet) {
                VStack {
                    HabitTagSelector()
                        .padding()
                }
                .presentationDetents([.height(200), .large])
                .presentationBackgroundInteraction(.automatic)
                .presentationBackground(.regularMaterial)
            }
            .onAppear {
                copyof()
            }
        }
    }
}

struct DatePickerView: View {
    @Binding var date: Date
    @Binding var showingDateSheet: Bool
    
    var body: some View {
        VStack {
            DatePicker("Select Date",
                       selection: $date,
                       in: ...Date(),
                       displayedComponents: .date)
            .datePickerStyle(GraphicalDatePickerStyle()) // 使用图形日期选择器样式
            
            Button(action: {
                showingDateSheet = false
            }) {
                Text("Done")
                    .font(.title2)
            }
        }
        .presentationDetents([.medium])
        .presentationBackgroundInteraction(.automatic)
        .presentationBackground(.regularMaterial)
    }
}

struct HabitSelectorView: View {
    var body: some View {
        Text("Habits")
    }
}

#Preview {
    JournalEditView()
        .modelContainer(for: [Journal.self, Habit.self], inMemory: true)
}
