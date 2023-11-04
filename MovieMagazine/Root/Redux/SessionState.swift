//
//  SessionState.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 04.11.2023.
//

import Foundation

struct SessionState: Reducer {
    var requestToken: String
    var expiresAt: String
    
    //MARK: - init(_:)
    init(
        requestToken: String = .init(),
        expiresAt: String = .init()
    ) {
        self.requestToken = requestToken
        self.expiresAt = expiresAt
    }
    
    //MARK: - Reducer
    mutating func reduce(_ action: Action) {
        switch action {
        case let action as SessionActions.UpdateRequestToken:
            self.requestToken = action.token
            
        case let action as SessionActions.UpdateExpirationDate:
            self.expiresAt = action.expirationDate
            
        default: break
        }
    }
}
