//
//  LoginActions.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation

public enum LoginActions {
    public struct UpdateLogin: Action {
        public let login: String
        
        public init(_ login: String) {
            self.login = login
        }
    }
    
    public struct UpdatePassword: Action {
        public let password: String
        
        public init(_ password: String) {
            self.password = password
        }
    }
    
    public struct Login: Action {}
    
    public struct LoginGuest: Action {}
    
    public struct InvalidCredentials: Action {}
    
    public struct Logout: Action {}
}
