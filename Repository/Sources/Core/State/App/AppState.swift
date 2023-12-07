//
//  AppState.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation
import ReduxCore

public typealias AppGraph = Graph<AppState, Action>
public typealias AppStore = Store<AppState, Action>
public typealias AppObserver = Observer<AppGraph>

public protocol Reducer {
    mutating func reduce(_ action: Action)
}

public struct AppState: Reducer {
    public var loginViewState: LoginViewState
    public var loginStatus: LoginStatus
    public var sessionState: SessionState
    public var loginFlow: LoginFlow
    
    //MARK: - init(_:)
    public init(
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
    public mutating func reduce(_ action: Action) {
        loginViewState.reduce(action)
        loginStatus.reduce(action)
        sessionState.reduce(action)
        loginFlow.reduce(action)
    }
}
