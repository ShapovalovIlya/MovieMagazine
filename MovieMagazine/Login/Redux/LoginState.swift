//
//  LoginState.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation
import Validator

struct LoginState: Reducer {
    var username: CredentialStatus
    var password: CredentialStatus
    var progress: LoginStatus
    
    var isCredentialValid: Bool {
        guard
            case .valid = username,
            case .valid = password
        else {
            return false
        }
        return true
    }
    
    init(
        email: CredentialStatus = .init(),
        password: CredentialStatus = .init(),
        progress: LoginStatus = .init()
    ) {
        self.username = email
        self.password = password
        self.progress = progress
    }
    
    mutating func reduce(_ action: Action) {
        switch action {
        case let action as LoginActions.UpdateLogin:
            self.username = .invalid(action.login)
         
        case let action as LoginActions.ValidatedLogin:
            self.username = action.login
            
        case let action as LoginActions.ValidatedPassword:
            self.password = action.password
            
        case let action as LoginActions.UpdatePassword:
            self.password = .invalid(action.password)
         
        case let action as LoginActions.UpdateProgress:
            self.progress = action.progress
            
        case is LoginActions.LoginButtonTap:
            self.progress = .loading
            
        default: break
        }
    }
    
}

extension LoginState {
    enum LoginStatus: Equatable {
        case none
        case loading
        case invalidCredentials
        case success
        case error(Error)
        
        init() { self = .none }
        
        static func == (lhs: LoginState.LoginStatus, rhs: LoginState.LoginStatus) -> Bool {
            String(describing: lhs) == String(describing: rhs)
        }
    }
    
    enum CredentialStatus: Equatable {
        case valid(String)
        case invalid(String)
        case empty
        
        init() { self = .empty }
        
        var value: String {
            switch self {
            case .valid(let string): return string
            case .invalid(let string): return string
            case .empty: return .init()
            }
        }
        
        var isValid: Bool {
            guard case .invalid = self else {
                return true
            }
            return false
        }
    }
}
