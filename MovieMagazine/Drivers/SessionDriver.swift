//
//  SessionDriver.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 09.11.2023.
//

import Foundation
import NetworkOperator
import Endpoint
import Analytics
import ReduxCore
import Models
import Core

final class SessionDriver {
    //MARK: - Private properties
    private let queue = DispatchQueue(label: "SessionDriver", qos: .utility)
    private let networkOperator: NetworkOperator
    private let networkCoder: NetworkCoder
    private let analytics: Analytics?
    private let bearer: Bearer = .init(ApiKeys.bearer)
    
    private(set) lazy var asObserver: AppObserver = .init(
        queue: queue,
        observe: process(graph:)
    )
    
    //MARK: - init(_:)
    init(analytics: Analytics? = nil) {
        self.analytics = analytics
        networkOperator = .init(queue: queue)
        networkCoder = .init(keyCodingStrategy: .convertSnakeCase)
        log(event: #function)
    }
    
    deinit {
        log(event: #function)
    }
}

private extension SessionDriver {
    func process(graph: AppGraph) -> AppObserver.Status {
        switch graph.state.loginFlow {
        case .none: break
            
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
                if let sessionRequest = composeValidatedSessionRequest(with: id, graph) {
                    sessionRequest
                }
            }
        case let .guestSession(id):
            networkOperator.process {
                request(
                    .createGuestSession(bearer),
                    id: id,
                    handler: guestSessionHandler(graph.dispatch)
                )
            }
        }
        return .active
    }
    
    
    
    func composeValidatedSessionRequest(with id: UUID, _ graph: AppGraph) -> NetworkOperator.Request? {
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
            graph.dispatch(SessionActions.SessionRequestFailed(error))
            return nil
        }
    }

    
    func composeTokenValidation(with id: UUID, _ graph: AppGraph) -> NetworkOperator.Request? {
        switch networkCoder.encode({
            TokenRequest(
                username: graph.loginViewState.username,
                password: graph.loginViewState.password,
                requestToken: graph.sessionState.requestToken
            )
        }) {
        case .success(let data):
            return request(
                .createSessionWithCredentials(bearer),
                id: id,
                data: data,
                handler: validationHandler(graph.dispatch)
            )
            
        case .failure(let error):
            graph.dispatch(SessionActions.TokenRequestFailed(error))
            return nil
        }
    }
    
    //MARK: - Handlers
    func guestSessionHandler(_ dispatcher: @escaping (Action) -> Void) -> ResultCompletion {
        { [weak self] result in
            self?.dispatchResult(
                dispatcher,
                type: SessionResponse.self,
                successAction: { SessionActions.UpdateSession(.guest($0.sessionId)) },
                failureAction: SessionActions.SessionRequestFailed.init
            )(result)
        }
    }

    
    func validatedSessionHandler(_ dispatcher: @escaping (Action) -> Void) -> ResultCompletion {
        { [weak self] result in
            self?.dispatchResult(
                dispatcher,
                type: SessionResponse.self,
                successAction: { SessionActions.UpdateSession(.validated($0.sessionId)) },
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
    
    //MARK: - Helpers
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
    
    func log(event: String) {
        analytics?.send(name: "SessionDriver", info: event)
    }
}
