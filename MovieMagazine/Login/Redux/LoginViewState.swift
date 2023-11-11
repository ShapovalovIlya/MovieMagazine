//
//  LoginViewState.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation
import Validator

struct LoginViewState: Reducer {
    var password: String
    var username: String
    
    //MARK: - init(_:)
    init(
        email: String = .init(),
        password: String = .init()
    ) {
        self.username = email
        self.password = password
    }
    
    //MARK: - Reduce
    mutating func reduce(_ action: Action) {
        switch action {
        case let action as LoginActions.UpdateLogin:
            self.username = action.login
         
        case let action as LoginActions.UpdatePassword:
            self.password = action.password
                     
        default: break
        }
    }
    
}
