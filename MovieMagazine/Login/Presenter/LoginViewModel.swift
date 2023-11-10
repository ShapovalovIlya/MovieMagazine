//
//  LoginViewModel.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation

struct LoginViewModel {
    let loginField: String
    let isLoginValid: Bool
    let passwordField: String
    let isPasswordValid: Bool
    let isLoginButtonActive: Bool
    
    enum CredentialStatus: Equatable {
        case valid(String)
        case invalid(String)
        case empty
        
        init() { self = .empty }
        
        var value: String {
            switch self {
            case .valid(let string): return string
            case .invalid(let string): return string
            case .empty: return .init()
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
