//
//  GraphStore.swift
//  MovieMagazine
//
//  Created by Шаповалов Илья on 02.11.2023.
//

import Foundation

@dynamicMemberLookup
final class GraphStore: Observer {
    private let store: Store
    private var observers: [UUID: Observer] = .init()
    
    private var graph: Graph
    
    let id: UUID = .init()
    let queue: DispatchQueue = .init(label: "GraphStore queue")
    
    var observe: (Graph) -> Status {
        { [weak self] graph in
            guard let self else { return .dead }
            queue.async {
                self.graph = graph
                self.observers
                    .map(\.value)
                    .forEach(self.notify)
            }
            return .active
        }
    }
    
    //MARK: - init(_:)
    init(store: @escaping () -> Store) {
        self.store = store()
        self.graph = .init(
            state: self.store.state,
            dispatch: self.store.dispatch
        )
        self.store.subscribe(self)
    }
    
    //MARK: - Public methods
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

private extension GraphStore {
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
