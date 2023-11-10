//
//  LoginViewModel.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation

struct LoginViewModel {
    let loginField: FieldState
    let passwordField: FieldState

    var isLoginButtonActive: Bool {
        guard 
            case .valid = loginField,
            case .valid = passwordField
        else {
            return false
        }
        return true
    }
    
    enum FieldState: Equatable {
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
