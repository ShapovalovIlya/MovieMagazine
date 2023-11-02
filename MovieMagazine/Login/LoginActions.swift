//
//  LoginActions.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation

enum LoginActions {
    struct UpdateLogin: Action {
        var login: String
    }
    
    struct UpdatePassword: Action {
        var login: String
    }
    
    struct LoginButtonTap: Action {}
}
