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
    typealias ResultCompletion = (Result<NetworkOperator.Response, Error>) -> Void
    
    func process(_ graph: Graph) {
        networkOperator.process {
            if let request = performLoginFlow(graph) {
                request
            }
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
    
    func performLoginFlow(_ graph: Graph) -> NetworkOperator.Request? {
        switch graph.loginFlow {
        case .none: return nil
        case .token(let id):
            return request(
                .createRequestToken(bearer),
                id: id,
                handler: tokenHandler(graph.dispatch)
            )
        case .validation(let id):
            return composeTokenValidation(with: id, graph)
            
        case .session(let uUID):
            <#code#>
        case .guestSession(let uUID):
            <#code#>
        }
    }
    
    func startSession(_ graph: Graph) {
        
    }
    
    func composeTokenValidation(with id: UUID, _ graph: Graph) -> NetworkOperator.Request? {
        switch networkCoder.encode({
            TokenRequest(
                username: graph.loginState.username,
                password: graph.loginState.password,
                requestToken: graph.sessionState.requestToken
            )
        }) {
        case .success(let data):
            return request(
                .createSessionWithCredentials(bearer),
                id: id,
                handler: <#T##ResultCompletion##ResultCompletion##(Result<NetworkOperator.Response, Error>) -> Void#>
            )
            
        case .failure(let error):
            graph.dispatch(SessionActions.TokenRequestFailed(error: error))
        }
    }
    
    func tokenHandler(_ dispatcher: @escaping (Action) -> Void) -> ResultCompletion {
        { [weak self] result in
            guard let self else { return }
            switch networkCoder.decode(TokenResponse.self, from: result.map(\.data)) {
            case .success(let token):
                dispatcher(SessionActions.ReceiveToken(token: token))
                
            case .failure(let error):
                dispatcher(SessionActions.TokenRequestFailed(error: error))
            }
        }
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
