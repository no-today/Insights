//
//  JournalEditView.swift
//  Insights
//
//  Created by whoog on 2024/5/20.
//

import SwiftUI

struct JournalEditView: View {
    @State private var timestamp = Date()
    @State private var content = ""
    @State private var showingDateSheet = false
    private var action: (Journal) -> Void
    
    init(_ action: @escaping (Journal) -> Void) {
        self.action = action
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                TextEditor(text: $content)
                    .frame(height: .infinity)
            }
            .padding()
            .navigationTitle(timestamp.formatted(date: .numeric, time: .omitted))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarTitleMenu {
                    Section {
                        Button(action: {
                            
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
                        
                    }, label: {
                        Label("Delete", systemImage: "trash")
                    })
                    .background(.red)
                }
                
                ToolbarItem {
                    Button(action: {
                        action(Journal(timestamp: timestamp, content: content))
                    }, label: {
                        Text("Done")
                    })
                }
                
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "fireworks")
                    })
                    
                    Spacer()
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "photo.on.rectangle")
                    })
                    
                    Spacer()
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "location")
                    })
                    Spacer()
                }
            }
            .presentationDetents([.large])
            .presentationBackgroundInteraction(.automatic)
            .presentationBackground(.regularMaterial)
        }
        .sheet(isPresented: $showingDateSheet) {
            DatePickerView(date: $timestamp, showingDateSheet: $showingDateSheet)
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
    JournalEditView { journal in
        print(journal)
    }
}
