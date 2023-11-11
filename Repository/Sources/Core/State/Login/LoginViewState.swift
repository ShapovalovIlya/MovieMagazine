//
//  LoginViewState.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation
import Validator
import Redux

public struct LoginViewState: Reducer {
    public var password: String
    public var username: String
    
    //MARK: - init(_:)
    public init(
        email: String = .init(),
        password: String = .init()
    ) {
        self.username = email
        self.password = password
    }
    
    //MARK: - Reduce
    public mutating func reduce(_ action: Action) {
        switch action {
        case let action as LoginActions.UpdateLogin:
            self.username = action.login
         
        case let action as LoginActions.UpdatePassword:
            self.password = action.password
                     
        default: break
        }
    }
    
}
