//
//  PersistentHelper.swift
//  Insights
//
//  Created by no-today on 2024/5/23.
//

import SwiftData
import SwiftUI

struct QueryView<Model: PersistentModel, Content: View>: View {
    @Query private var query: [Model]
    private var content: ([Model]) -> (Content)
    
    init(for type: Model.Type,
         filter: (() -> (Predicate<Model>))? = nil,
         sort: [SortDescriptor<Model>] = [],
         @ViewBuilder content: @escaping ([Model]) -> Content) {
        
        _query = Query(filter: filter?(), sort: sort)
        self.content = content
    }
    
    var body: some View {
        content(query)
    }
}

struct SectionedQueryView<Content: View, Model: PersistentModel, Key: Hashable>: View {
    @Query private var query: [Model]
    
    private var groupBy: (Model) -> Key
    private var content: ([QueryDataSection<Key, Model>]) -> (Content)
    
    init(for type: Model.Type,
         groupBy: @escaping ((Model) -> Key),
         filter: (() -> (Predicate<Model>))? = nil,
         sort: [SortDescriptor<Model>] = [],
         @ViewBuilder content: @escaping ([QueryDataSection<Key, Model>]) -> Content) {
        
        _query = Query(filter: filter?(), sort: sort)
        self.groupBy = groupBy
        self.content = content
    }
    
    var body: some View {
        content(groups())
    }
    
    private func groups() -> [QueryDataSection<Key, Model>] {
        let data: [Key:[Model]] = Dictionary(grouping: query, by: groupBy)
        let groups: [QueryDataSection] = data.keys.reduce([QueryDataSection]()) { partialResult, key in
            partialResult + [.init(key: key, items: data[key] ?? [])]
        }
        
        return groups
    }
}

struct QueryDataSection<Key: Hashable, Model: PersistentModel>: Identifiable {
    var id = UUID()
    var key: Key
    var items: [Model]
}
