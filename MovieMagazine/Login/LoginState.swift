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
    
    private let validator: Validator
    
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
        progress: LoginStatus = .none
    ) {
        self.email = email
        self.password = password
        self.progress = progress
        self.validator = .live
    }
    
    mutating func reduce(_ action: Action) {
        switch action {
        case let login as LoginActions.Login:
            if validator.isEmpty(login.value) {
                self.email = .empty
            }
            self.email = validator.validateEmail(login.value)
            ? .valid(login.value)
            : .invalid(login.value)
            
        case let password as LoginActions.Password:
            if validator.isEmpty(password.value) {
                self.password = .empty
            }
            self.email = validator.validatePassword(password.value)
            ? .valid(password.value)
            : .invalid(password.value)
            
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
