//
//  NetworkDriver.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation
import OSLog
import Endpoint
import SwiftFP

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
        process(graph)
        return .active
    }
    
    //MARK: - init(_:)
    init(logger: OSLog? = nil) {
        self.logger = logger
        adapter = .init(logger: logger)
    }
}

private extension NetworkDriver {
    typealias ProcessGraph = (Graph) -> Graph
    
    func process(_ graph: Graph) {
        validateToken(graph)
        
    }
    
    func startSession(_ graph: Graph) {
        
    }
    
    func validateToken(_ graph: Graph) {
        guard graph.sessionState.requestToken.isEmpty else { return }
        log(event: "perform token request")
        let taskId = UUID()
        let task = adapter.requestToken(
            bearer: ApiKeys.bearer,
            completion: processAction(for: graph, withId: taskId)
        )
        currentTasks.updateValue(task, forKey: taskId)
    }
    
    func processAction(for graph: Graph, withId id: UUID) -> (Result<TokenResponse, Error>) -> Void {
        { result in
            switch result {
            case let .success(tokenResponse):
                self.log(event: "token request success")
                graph.sessionState.requestToken = tokenResponse.requestToken
                graph.sessionState.expiresAt = tokenResponse.expiresAt
                
            case let .failure(error):
                self.log(event: "token request failed")
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
