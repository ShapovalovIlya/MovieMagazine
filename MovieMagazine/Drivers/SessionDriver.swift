//
//  SessionDriver.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 09.11.2023.
//

import Foundation
import NetworkOperator
import Endpoint
import OSLog

final class SessionDriver {
    //MARK: - Private properties
    private let queue = DispatchQueue(label: "SessionDriver", qos: .utility)
    private let networkOperator: NetworkOperator
    private let networkCoder: NetworkCoder
    private let logger: OSLog?
    private let bearer: Bearer = .init(ApiKeys.bearer)
    
    private(set) lazy var asObserver: Observer<Graph> = .init(
        queue: queue
    ) { [weak self] graph in
        guard let self else { return .dead }
        return .active
    }
    
    //MARK: - init(_:)
    init(logger: OSLog? = nil) {
        self.logger = logger
        networkOperator = .init(
            queue: queue,
            logger: logger
        )
        networkCoder = .init(keyCodingStrategy: .convertSnakeCase)
    }
}

private extension SessionDriver {
    func process(_ graph: Graph) {
        switch graph.loginFlow {
        case .none: return
            
        case let .token(id):
            networkOperator.process {
                request(
                    .createRequestToken(bearer),
                    id: id,
                    handler: tokenHandler(graph.dispatch)
                )
            }
        case let .validation(id):
            networkOperator.process {
                if let validationRequest = composeTokenValidation(with: id, graph) {
                    validationRequest
                }
            }
            
        case let .session(id):
            networkOperator.process {
                
            }
            
        case let .guestSession(id):
            networkOperator.process {
                
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
    
    func composeValidatedSessionRequest(with id: UUID, _ graph: Graph) -> NetworkOperator.Request? {
        switch networkCoder.encode({
            SessionRequest(requestToken: graph.sessionState.requestToken)
        }) {
        case .success(let data):
            return request(
                .createSession(bearer),
                id: id,
                data: data,
                handler: validatedSessionHandler(graph.dispatch)
            )
            
        case .failure(let error):
            graph.dispatch(SessionActions.SessionRequestFailed(error: error))
            return nil
        }
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
                handler: validationHandler(graph.dispatch)
            )
            
        case .failure(let error):
            graph.dispatch(SessionActions.TokenRequestFailed(error: error))
            return nil
        }
    }
    
    //MARK: - Handlers
    func guestSessionHandler(_ dispatcher: @escaping (Action) -> Void) -> ResultCompletion {
        { [weak self] result in
            self?.dispatchResult(
                dispatcher,
                type: SessionResponse.self,
                successAction: { SessionActions.ReceiveSession(session: .guest($0.sessionId)) },
                failureAction: SessionActions.SessionRequestFailed.init
            )(result)
        }
    }

    
    func validatedSessionHandler(_ dispatcher: @escaping (Action) -> Void) -> ResultCompletion {
        { [weak self] result in
            self?.dispatchResult(
                dispatcher,
                type: SessionResponse.self,
                successAction: { SessionActions.ReceiveSession(session: .validated($0.sessionId)) },
                failureAction: SessionActions.SessionRequestFailed.init
            )(result)
        }
    }
    
    func validationHandler(_ dispatcher: @escaping (Action) -> Void) -> ResultCompletion {
        { [weak self] result in
            self?.dispatchResult(
                dispatcher,
                type: TokenResponse.self,
                successAction: SessionActions.ReceiveToken.init,
                failureAction: SessionActions.TokenRequestFailed.init
            )(result)
        }
    }
    
    func tokenHandler(_ dispatcher: @escaping (Action) -> Void) -> ResultCompletion {
        { [weak self] result in
            self?.dispatchResult(
                dispatcher,
                type: TokenResponse.self,
                successAction: SessionActions.TokenValidated.init,
                failureAction: SessionActions.TokenValidationFailed.init
            )(result)
        }
    }
    
    func dispatchResult<T: Decodable>(
        _ dispatcher: @escaping (Action) -> Void,
        type: T.Type,
        successAction: @escaping (T) -> Action,
        failureAction: @escaping (Error) -> Action
    ) -> ResultCompletion {
        { result in
            switch self.networkCoder.decode(type.self, from: result.map(\.data)) {
            case .success(let success): dispatcher(successAction(success))
            case .failure(let failure): dispatcher(failureAction(failure))
            }
        }
    }
}
