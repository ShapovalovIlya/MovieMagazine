//
//  LoginState.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation

struct LoginState: Reducer {
    var email: CredentialStatus
    var password: CredentialStatus
    var progress: LoginStatus
    
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
    }
    
    mutating func reduce(_ action: Action) {
        switch action {
        case let login as LoginActions.Login:
            self.email = .valid(login.value)
            
        case let password as LoginActions.Password:
            self.password = .valid(password.value)
            
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
            case .valid(let string): string
            case .invalid(let string): string
            case .empty: .init()
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
