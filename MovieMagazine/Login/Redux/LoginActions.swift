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
    
    struct Login: Action {}
    
    struct LoginGuest: Action {}
    
    struct InvalidCredentials: Action {}
    
    struct Logout: Action {}
}
