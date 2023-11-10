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
    case invalidCredentials
    case success
    case error
    
    init() { self = .none }
    
    mutating func reduce(_ action: Action) {
        switch action {
        case is LoginActions.Login: self = .inProgress
        case is LoginActions.LoginGuest: self = .inProgress
        case is SessionActions.UpdateSession: self = .success
        case is SessionActions.SessionRequestFailed: self = .error
        case is SessionActions.TokenRequestFailed: self = .error
        case is SessionActions.TokenValidationFailed: self = .error
            
        default: return
        }
    }
    
}
