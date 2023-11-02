//
//  LoginState.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation
import Validator

struct LoginState: Reducer {
    var email: CredentialStatus
    var password: CredentialStatus
    var progress: LoginStatus
    var validator: Validator
    
    var isCredentialValid: Bool {
        guard
            case .valid = email,
            case .valid = password
        else {
            return false
        }
        return true
    }
    
    init(
        email: CredentialStatus = .empty,
        password: CredentialStatus = .empty,
        progress: LoginStatus = .none,
        validator: Validator = .live
    ) {
        self.email = email
        self.password = password
        self.progress = progress
        self.validator = validator
    }
    
    mutating func reduce(_ action: Action) {
        switch action {
        case let action as LoginActions.UpdateLogin:
            if validator.isEmpty(action.login) {
                self.email = .empty
            }
            self.email = validator.validateEmail(action.login)
            ? .valid(action.login)
            : .invalid(action.login)
            
        case let action as LoginActions.UpdatePassword:
            if validator.isEmpty(action.login) {
                self.password = .empty
            }
            self.email = validator.validatePassword(action.login)
            ? .valid(action.login)
            : .invalid(action.login)
            
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
        case error(Error)
        
        static func == (lhs: LoginState.LoginStatus, rhs: LoginState.LoginStatus) -> Bool {
            String(describing: lhs) == String(describing: rhs)
        }
    }
    
    enum CredentialStatus {
        case valid(String)
        case invalid(String)
        case empty
        
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
