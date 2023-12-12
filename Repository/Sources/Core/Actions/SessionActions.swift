//
//  SessionActions.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 04.11.2023.
//

import Foundation
import Models

public enum SessionActions {
    public struct ReceiveToken: Action {
        public let token: TokenResponse
        
        public init(_ token: TokenResponse) {
            self.token = token
        }
    }
    
    public struct TokenRequestFailed: Action, Error {
        public let error: Error
        
        public init(_ error: Error) {
            self.error = error
        }
    }
    
    public struct TokenValidated: Action {
        public let token: TokenResponse
        
        public init(_ token: TokenResponse) {
            self.token = token
        }
    }
    
    public struct TokenValidationFailed: Action, Error {
        public let error: Error
        
        public init(_ error: Error) {
            self.error = error
        }
    }
    
    public struct UpdateSession: Action {
        public let session: SessionState.SessionType
        
        public init(_ session: SessionState.SessionType) {
            self.session = session
        }
    }
    
    public struct SessionRequestFailed: Action {
        public let error: Error
        
        public init(_ error: Error) {
            self.error = error
        }
    }
}
