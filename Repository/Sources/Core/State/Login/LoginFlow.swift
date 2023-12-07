//
//  LoginFlow.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 05.11.2023.
//

import Foundation

public enum LoginFlow: Reducer, Equatable {
    case none
    case token(UUID)
    case validation(UUID)
    case session(UUID)
    case guestSession(UUID)
    
    public init() { self = .none }
    
    mutating public func reduce(_ action: Action) {
        switch action {
        case is LoginActions.Login: self = .token(UUID())
        case is LoginActions.LoginGuest: self = .guestSession(UUID())
        case is SessionActions.ReceiveToken: self = .validation(UUID())
        case is SessionActions.TokenValidated: self = .session(UUID())
        case is SessionActions.UpdateSession: self = .none
        case is SessionActions.TokenRequestFailed: self = .none
        case is SessionActions.TokenValidationFailed: self = .none
        case is SessionActions.SessionRequestFailed: self = .none
        default: break
        }
    }
}
