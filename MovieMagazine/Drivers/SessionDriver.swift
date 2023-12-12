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
import Extensions
import SwiftFP

final class SessionDriver {
    //MARK: - Private properties
    private let queue = DispatchQueue(label: "SessionDriver", qos: .utility)
    private let analytics: Analytics?
    private let bearer: Bearer = .init(ApiKeys.bearer)
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    private(set) lazy var asObserver: AppObserver = .init(
        queue: queue,
        scope: SessionScope.init,
        observeScope: process(_:)
    )
    
    //MARK: - init(_:)
    init(analytics: Analytics? = nil) {
        self.analytics = analytics
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        log(event: #function)
    }
    
    deinit {
        log(event: #function)
    }
}

private extension SessionDriver {
    func process(_ scope: SessionScope) -> AppObserver.Status {
        switch scope.flow {
        case let .token(id):
            requestTokenTask(dispatcher: scope.dispatch)
            
        case let .validation(id):
            validateTokenTask(
                .init(
                    username: scope.username,
                    password: scope.password,
                    requestToken: scope.requestToken
                ),
                dispatcher: scope.dispatch
            )
        case let .session(id):
            getSessionTask(
                .init(requestToken: scope.requestToken),
                dispatcher: scope.dispatch
            )
        case let .guestSession(id):
            guestSessionTask(dispatcher: scope.dispatch)
            
        case .none:
            break
        }
        return .active
    }
        
    func requestTokenTask(dispatcher: @escaping (Action) -> Void) {
        Task(priority: .background) {
            switch await request(.createRequestToken(bearer), response: TokenResponse.self) {
            case .success(let token): dispatcher(SessionActions.TokenValidated(token))
            case .failure(let error): dispatcher(SessionActions.TokenValidationFailed(error))
            }
        }
    }
    
    func validateTokenTask(_ token: TokenRequest, dispatcher: @escaping (Action) -> Void) {
        Task(priority: .background) {
            switch await request(.createSessionWithCredentials(bearer), payload: token, response: TokenResponse.self) {
            case .success(let token): dispatcher(SessionActions.ReceiveToken(token))
            case .failure(let error): dispatcher(SessionActions.TokenRequestFailed(error))
            }
        }
    }
    
    func getSessionTask(_ payload: SessionRequest, dispatcher: @escaping (Action) -> Void) {
        Task(priority: .background) {
            switch await request(.createSession(bearer), payload: payload, response: SessionResponse.self).map(\.sessionId) {
            case .success(let sessionId): dispatcher(SessionActions.UpdateSession(.validated(sessionId)))
            case .failure(let error): dispatcher(SessionActions.SessionRequestFailed(error))
            }
        }
    }
    
    func guestSessionTask(dispatcher: @escaping (Action) -> Void) {
        Task(priority: .background) {
            switch await request(.createGuestSession(bearer), response: SessionResponse.self).map(\.sessionId) {
            case .success(let sessionId): dispatcher(SessionActions.UpdateSession(.guest(sessionId)))
            case .failure(let error): dispatcher(SessionActions.SessionRequestFailed(error))
            }
        }
    }
    
    func request<T: Decodable>(
        _ endpoint: TheMovieDB,
        payload: Encodable? = nil,
        response type: T.Type
    ) async -> Result<T, Error> {
        do {
            let request: URLRequest
            switch payload {
            case .none:
                request = endpoint.makeRequest()
                
            case .some(let encodable):
                let data = try encoder.encode(encodable)
                request = endpoint.makeRequest(with: data)
            }
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try decoder.decode(type.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(error)
        }
    }

    
    //MARK: - Log(event:)
    func log(event: String) {
        analytics?.send(name: "SessionDriver", info: event)
    }
    
    //MARK: - SessionScope
    struct SessionScope: Equatable {
        let flow: LoginFlow
        let username: String
        let password: String
        let requestToken: String
        
        let dispatch: (Action) -> Void
        
        init(_ graph: AppGraph) {
            self.flow = graph.state.loginFlow
            self.username = graph.loginViewState.username
            self.password = graph.loginViewState.password
            self.requestToken = graph.sessionState.requestToken
            self.dispatch = graph.dispatch
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.flow == rhs.flow
        }
    }
}
