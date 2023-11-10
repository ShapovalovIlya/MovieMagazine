//
//  LoginState.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation
import Validator

struct LoginState: Reducer {
    var password: String
    var username: String
    var progress: LoginStatus
    
    //MARK: - init(_:)
    init(
        email: String = .init(),
        password: String = .init(),
        progress: LoginStatus = .init()
    ) {
        self.username = email
        self.password = password
        self.progress = progress
    }
    
    //MARK: - Reduce
    mutating func reduce(_ action: Action) {
        switch action {
        case let action as LoginActions.UpdateLogin:
            self.username = action.login
         
        case let action as LoginActions.UpdatePassword:
            self.password = action.password
         
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
}
