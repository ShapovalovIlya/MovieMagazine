//
//  Graph.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation

@dynamicMemberLookup
struct Graph {
    let state: AppState
    let dispatch: (Action) -> Void
    
    //MARK: - init(_:)
    init(
        state: AppState,
        dispatch: @escaping (Action) -> Void
    ) {
        self.state = state
        self.dispatch = dispatch
    }
    
    subscript<T>(dynamicMember keyPath: KeyPath<AppState, T>) -> T {
        state[keyPath: keyPath]
    }
}
