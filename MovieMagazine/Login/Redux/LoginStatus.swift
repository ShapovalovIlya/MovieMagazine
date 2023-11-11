//
//  LoginStatus.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 11.11.2023.
//

import Foundation

enum LoginStatus: Reducer {
    case none
    case inProgress
    case invalidCredentials(Error)
    case success
    case error(Error)
    
    init() { self = .none }
    
    mutating func reduce(_ action: Action) {
        switch action {
        case is LoginActions.Login: self = .inProgress
        case is LoginActions.LoginGuest: self = .inProgress
        case is SessionActions.UpdateSession: self = .success
        case let action as SessionActions.SessionRequestFailed:
            self = .error(action.error)
            
        case let action as SessionActions.TokenRequestFailed:
            self = .error(action.error)
            
        case let action as SessionActions.TokenValidationFailed:
            self = .error(action.error)
            
        default: return
        }
    }
    
}
