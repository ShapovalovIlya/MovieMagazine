//
//  AppState.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation

struct AppState: Reducer {
    var loginState: LoginState
    
    //MARK: - init(_:)
    init() {
        loginState = .init()
    }
    
    //MARK: - Reducer
    mutating func reduce(_ action: Action) {
        loginState.reduce(action)
    }
}
