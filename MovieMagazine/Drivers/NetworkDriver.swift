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
    private let queue: DispatchQueue = .init(label: "NetworkDriver")
    private var logger: OSLog?
    
    private(set) lazy var asObserver: Observer<Graph> = .init(
        queue: queue
    ) { [weak self] graph in
        guard let self else {
            return .dead
        }
        dispatch(graph)
        return .active
    }
    
    //MARK: - init(_:)
    init(logger: OSLog? = nil) {
        self.logger = logger
        adapter = .init(logger: logger)
    }
}

private extension NetworkDriver {
    func dispatch(_ graph: Graph) {
        
    }
}
