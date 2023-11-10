//
//  LoginActions.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation

enum LoginActions {
    struct UpdateLogin: Action {
        let login: String
    }
    
    struct UpdatePassword: Action {
        let password: String
    }
    
    struct UpdateProgress: Action {
        let progress: LoginState.LoginStatus
    }
    
    struct LoginButtonTap: Action {}
    
    struct LoginGuestButtonTap: Action {}
}
