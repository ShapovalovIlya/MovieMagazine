//
//  SessionState.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 04.11.2023.
//

import Foundation
import Redux

public struct SessionState: Reducer, Codable {
    public var requestToken: String
    public var session: SessionType
    public var expiresAt: String
    
    //MARK: - init(_:)
    public init(
        requestToken: String = .init(),
        session: SessionType = .none,
        expiresAt: String = .init()
    ) {
        self.requestToken = requestToken
        self.expiresAt = expiresAt
        self.session = session
    }
    
    //MARK: - Reducer
    public mutating func reduce(_ action: Action) {
        switch action {
        case let action as SessionActions.ReceiveToken:
            self.requestToken = action.token.requestToken
            self.expiresAt = action.token.expiresAt
            
        case let action as SessionActions.UpdateSession:
            self.session = action.session
            
        default: break
        }
    }
}

public extension SessionState {
    enum SessionType: Codable {
        case none
        case validated(String)
        case guest(String)
        
        public var value: String {
            switch self {
            case .none: return .init()
            case .validated(let string): return string
            case .guest(let string): return string
            }
        }
    }
}
