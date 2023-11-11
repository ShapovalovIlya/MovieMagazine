//
//  AppState.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation
import Core

struct AppState: Reducer {
    var loginViewState: LoginViewState
    var loginStatus: LoginStatus
    var sessionState: SessionState
    var loginFlow: LoginFlow
    
    //MARK: - init(_:)
    init(
        loginViewState: LoginViewState = .init(),
        loginStatus: LoginStatus = .init(),
        sessionState: SessionState = .init(),
        loginFlow: LoginFlow = .init()
    ) {
        self.loginViewState = loginViewState
        self.loginStatus = loginStatus
        self.sessionState = sessionState
        self.loginFlow = loginFlow
    }
    
    //MARK: - Reducer
    mutating func reduce(_ action: Action) {
        loginViewState.reduce(action)
        loginStatus.reduce(action)
        sessionState.reduce(action)
        loginFlow.reduce(action)
    }
}
