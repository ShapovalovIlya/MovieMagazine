//
//  SessionActions.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 04.11.2023.
//

import Foundation

enum SessionActions {
    struct ReceiveToken: Action {
        let token: TokenResponse
    }
    
    struct TokenRequestFailed: Action {
        let error: Error
    }
    
    struct TokenValidated: Action {
        let token: TokenResponse
    }
    
    struct TokenValidationFailed: Action {
        let error: Error
    }
    
    struct UpdateSession: Action {
        let session: SessionState.SessionType
    }
    
    struct SessionRequestFailed: Action {
        let error: Error
    }
}
