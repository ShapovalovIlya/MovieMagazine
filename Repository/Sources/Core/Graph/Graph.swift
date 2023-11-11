//
//  Graph.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation
import Redux

@dynamicMemberLookup
public struct Graph {
    public let state: AppState
    public let dispatch: (Action) -> Void
    
    //MARK: - init(_:)
    public init(
        state: AppState,
        dispatch: @escaping (Action) -> Void
    ) {
        self.state = state
        self.dispatch = dispatch
    }
    
    public func dispatch(_ actions: Action...) {
        actions.forEach(dispatch)
    }
    
    public subscript<T>(dynamicMember keyPath: KeyPath<AppState, T>) -> T {
        state[keyPath: keyPath]
    }
}
