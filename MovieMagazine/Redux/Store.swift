//
//  Store.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 28.10.2023.
//

import Foundation

protocol Reducer {
    mutating func reduce(_ action: Action)
}

protocol Action {}

@dynamicMemberLookup
final class Store {
    typealias Reducer = (inout AppState, Action) -> Void
    
    var graph: Graph { .init(state: state, dispatch: dispatch) }
    
    //MARK: - Private properties
    private var state: AppState
    private let reducer: Reducer
    private let queue: DispatchQueue = .init(label: "Store queue")
    private var observers: Set<Observer<Graph>> = .init()
    
    //MARK: - init(_:)
    init(
        initial state: AppState,
        reducer: @escaping Reducer
    ) {
        self.state = state
        self.reducer = reducer
    }
    
    //MARK: - Public methods
    @inlinable
    func subscribe(_ observer: Observer<Graph>) {
        queue.sync {
            observers.insert(observer)
            notify(observer)
        }
    }
    
    subscript<T>(dynamicMember keyPath: KeyPath<Graph, T>) -> T {
        graph[keyPath: keyPath]
    }
}

private extension Store {
    func dispatch(_ action: Action) {
        queue.sync {
            reducer(&state, action)
            observers.forEach(notify)
        }
    }
    
    func notify(_ observer: Observer<Graph>) {
        let state = self.graph
        observer.queue.async {
            let status = observer.observe(state)
            
            guard case .dead = status else { return }
            self.queue.async {
                self.observers.remove(observer)
            }
        }
    }
}
