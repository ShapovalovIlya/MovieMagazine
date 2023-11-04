//
//  AppState.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation

struct AppState: Reducer {
    var loginState: LoginState
    var sessionState: SessionState
    var error: Error?
    
    //MARK: - init(_:)
    init(
        loginState: LoginState = .init(),
        sessionState: SessionState = .init(),
        error: Error? = nil
    ) {
        self.loginState = loginState
        self.sessionState = sessionState
        self.error = error
    }
    
    //MARK: - Reducer
    mutating func reduce(_ action: Action) {
        loginState.reduce(action)
        sessionState.reduce(action)
    }
}
