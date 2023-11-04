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
    
    struct ValidatedLogin: Action {
        let login: LoginState.CredentialStatus
    }
    
    struct UpdatePassword: Action {
        let password: String
    }
    
    struct ValidatedPassword: Action {
        let password: LoginState.CredentialStatus
    }
    
    struct UpdateProgress: Action {
        let progress: LoginState.LoginStatus
    }
    
    struct LoginButtonTap: Action {}
}
