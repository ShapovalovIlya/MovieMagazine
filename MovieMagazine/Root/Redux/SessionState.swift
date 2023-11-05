//
//  SessionState.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 04.11.2023.
//

import Foundation

struct SessionState: Reducer, Codable {
    var requestToken: String
    var session: SessionType
    var expiresAt: String
    
    //MARK: - init(_:)
    init(
        requestToken: String = .init(),
        session: SessionType = .none,
        expiresAt: String = .init()
    ) {
        self.requestToken = requestToken
        self.expiresAt = expiresAt
        self.session = session
    }
    
    //MARK: - Reducer
    mutating func reduce(_ action: Action) {
        switch action {
        case let action as SessionActions.UpdateRequestToken:
            self.requestToken = action.token
            
        case let action as SessionActions.UpdateExpirationDate:
            self.expiresAt = action.expirationDate
            
        case let action as SessionActions.UpdateSession:
            self.session = action.session
            
        default: break
        }
    }
}

extension SessionState {
    enum SessionType: Codable {
        case none
        case validated(String)
        case guest(String)
        
        var value: String {
            switch self {
            case .none: return .init()
            case .validated(let string): return string
            case .guest(let string): return string
            }
        }
    }
}
