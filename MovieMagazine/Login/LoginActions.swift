//
//  LoginActions.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation

enum LoginActions {
    struct Login: Action {
        var value: String
    }
    
    struct Password: Action {
        var value: String
    }
    
    struct LoginButtonTap: Action {}
}
