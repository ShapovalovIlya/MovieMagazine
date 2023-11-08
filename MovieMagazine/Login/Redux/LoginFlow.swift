//
//  LoginFlow.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 05.11.2023.
//

import Foundation

enum LoginFlow: Reducer {
    case none
    case token(UUID)
    case validation(UUID)
    case session(UUID)
    case guestSession(UUID)
    
    init() { self = .none }
    
    mutating func reduce(_ action: Action) {
        switch action {
        case is LoginActions.LoginButtonTap: self = .token(UUID())
        case is LoginActions.LoginGuestButtonTap: self = .guestSession(UUID())
        case is SessionActions.ReceiveToken: self = .validation(UUID())
        case is SessionActions.TokenValidated: self = .session(UUID())
        default: break
        }
    }
}
