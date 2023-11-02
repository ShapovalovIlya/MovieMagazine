//
//  NetworkDriver.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation
import OSLog

final class NetworkDriver {
    private let adapter: NetworkAdapter
    private let store: GraphStore
    private let queue: DispatchQueue = .init(label: "NetworkDriver")
    
    lazy var asObserver: Observer<Graph> = .init(queue: queue) { [weak self] graph in
        guard let self else {
            return .dead
        }
        dispatch(graph)
        return .active
    }
    
    //MARK: - init(_:)
    init(
        store: GraphStore,
        logger: OSLog? = nil
    ) {
        self.store = store
        adapter = .init(logger: logger)
    }
}

private extension NetworkDriver {
    func dispatch(_ graph: Graph) {
        
    }
}
