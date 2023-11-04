//
//  NetworkDriver.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation
import OSLog
import Endpoint

final class NetworkDriver {
    private let adapter: NetworkAdapter
    private let queue: DispatchQueue = .init(label: "NetworkDriver")
    private var logger: OSLog?
    private var currentTasks: [UUID: URLSessionDataTask] = .init()
    
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
        if graph.sessionState.requestToken.isEmpty {
            log(event: "perform request token")
            let taskId = UUID()
            let task = adapter.requestToken(
                bearer: ApiKeys.bearer,
                completion: transformToAction(for: graph, withId: taskId)
            )
            currentTasks.updateValue(task, forKey: taskId)
        }
    }
    
    func transformToAction(for graph: Graph, withId id: UUID) -> (Result<RequestTokenResponse, Error>) -> Void {
        { result in
            switch result {
            case let .success(tokenResponse):
                self.log(event: "request token success")
                graph.sessionState.requestToken = tokenResponse.requestToken
                graph.sessionState.expiresAt = tokenResponse.expiresAt
                
            case let .failure(error):
                self.log(event: "request token failed")
                graph.dispatch(AppActions.RaiseError(error: error))
            }
            self.currentTasks.removeValue(forKey: id)
        }
    }
    
    func log(event: String) {
        guard let logger else { return }
        os_log("NetworkDriver: %@", log: logger, type: .debug, event)
    }
}
