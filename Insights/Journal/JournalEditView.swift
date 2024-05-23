//
//  JournalEditView.swift
//  Insights
//
//  Created by whoog on 2024/5/20.
//

import SwiftUI

struct JournalEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDateSheet = false
    @State private var selectedButton: ButtonType? = nil
    
    @State private var journal: Journal
    private(set) var action: (Journal) -> Void
    
    init(_ journal: Journal? = nil, action: @escaping (Journal) -> Void) {
        self.journal = journal ?? Journal.initial()
        self.action = action
    }
    
    enum ButtonType: String, CaseIterable {
        case prompt = "fireworks"
        case photo = "photo"
        case location = "location"
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                GeometryReader { geometry in
                    TextEditor(text: $journal.content)
                    .frame(height: geometry.size.height)
                    .onTapGesture {
                        selectedButton = nil
                    }
                }
                .padding()
            }
            .navigationTitle(journal.date.formatted(date: .numeric, time: .omitted))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarTitleMenu {
                    Section {
                        Button(action: {
                            journal.date = journal.timestamp
                        }, label: {
                            Text("Journal Date")
                            Text(journal.timestamp.formatted(date: .complete, time: .omitted))
                        })
                        
                        Button(action: {
                            showingDateSheet = true
                        }, label: {
                            Label("Custom Date", systemImage: "calendar")
                        })
                    }
                    
                    Button(role: .destructive, action: {
                        
                    }, label: {
                        Label("Delete", systemImage: "trash")
                    })
                }
                
                ToolbarItem {
                    Button(action: {
                        action(journal)
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Done")
                    })
                }
                
                ToolbarItemGroup(placement: .bottomBar) {
                    ForEach(ButtonType.allCases, id: \.rawValue) { bt in
                        Spacer()
                        Button(action: {
                            selectedButton = bt
                        }, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 11, style: .continuous)
                                    .foregroundColor(.gray.opacity(0.3))
                                    .foregroundStyle(.tint)
                                    .shadow(radius: 3)
                                    .opacity(selectedButton == bt ? 1 : 0)

                                Image(systemName: bt.rawValue)
                                    .foregroundStyle(.blue)
                            }
                        })
                    }
                    Spacer()
                }
            }
            .presentationDetents([.large])
            .presentationBackgroundInteraction(.automatic)
            .presentationBackground(.regularMaterial)
        }
        .sheet(isPresented: $showingDateSheet) {
            DatePickerView(date: $journal.date, showingDateSheet: $showingDateSheet)
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

#Preview {
    JournalEditView { item in
        print(item)
    }
}
