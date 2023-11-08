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
    var loginFlow: LoginFlow
    var error: Error?
    
    //MARK: - init(_:)
    init(
        loginState: LoginState = .init(),
        sessionState: SessionState = .init(),
        loginFlow: LoginFlow = .init(),
        error: Error? = nil
    ) {
        self.loginState = loginState
        self.sessionState = sessionState
        self.loginFlow = loginFlow
        self.error = error
    }
    
    //MARK: - Reducer
    mutating func reduce(_ action: Action) {
        loginState.reduce(action)
        sessionState.reduce(action)
        loginFlow.reduce(action)
    }
}
