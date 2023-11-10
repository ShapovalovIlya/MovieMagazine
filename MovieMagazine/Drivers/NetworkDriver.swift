//
//  NetworkDriver.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation
import OSLog
import Endpoint
import NetworkOperator

typealias ResultCompletion = (Result<NetworkOperator.Response, Error>) -> Void

final class NetworkDriver {
    private let networkOperator: NetworkOperator
    private let networkCoder: NetworkCoder
    private let queue: DispatchQueue = .init(label: "NetworkDriver")
    private let bearer: Bearer = .init(ApiKeys.bearer)
    private var logger: OSLog?
    
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
        networkOperator = .init(
            queue: self.queue,
            logger: logger
        )
        networkCoder = .init(
            keyCodingStrategy: .convertSnakeCase
        )
    }
}

private extension NetworkDriver {
    
    func process(_ graph: Graph) {
        networkOperator.process {
        }
    }
    
    func request(
        _ endpoint: TheMovieDB,
        id: UUID = .init(),
        data: Data? = nil,
        handler: @escaping ResultCompletion
    ) -> NetworkOperator.Request {
        return .init(
            id: id,
            request: endpoint.makeRequest(with: data),
            handler: handler
        )
    }
        
    func startSession(_ graph: Graph) {
        
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
        }
    }
    
    func log(event: String) {
        guard let logger else { return }
        os_log("NetworkDriver: %@", log: logger, type: .debug, event)
    }
}
