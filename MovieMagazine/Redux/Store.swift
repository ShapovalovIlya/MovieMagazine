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
    private var observers: [UUID: Observer] = .init()
    
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
    func dispatch(_ action: Action) {
        queue.sync {
            reducer(&state, action)
            observers.map(\.value).forEach(notify)
        }
    }
    
    @inlinable
    func subscribe(_ observer: Observer) {
        queue.sync {
            observers.updateValue(observer, forKey: observer.id)
            notify(observer)
        }
    }
    
    subscript<T>(dynamicMember keyPath: KeyPath<Graph, T>) -> T {
        graph[keyPath: keyPath]
    }
}

private extension Store {
    func notify(_ observer: Observer) {
        observer.queue.async { [state = self.graph] in
            let status = observer.observe(state)
            
            guard case .dead = status else { return }
            self.queue.async {
                self.observers.removeValue(forKey: observer.id)
            }
        }
    }
}
