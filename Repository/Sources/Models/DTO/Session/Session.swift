//
//  SessionRequest.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 04.11.2023.
//

import Foundation

public struct SessionRequest: Encodable {
    public let requestToken: String
    
    public init(requestToken: String) {
        self.requestToken = requestToken
    }
}

public struct SessionResponse: Decodable {
    public let success: Bool
    public let sessionId: String
    
    public init(success: Bool, sessionId: String) {
        self.success = success
        self.sessionId = sessionId
    }
}

public struct GuestSession: Decodable {
    public let success: Bool
    public let guestSessionId: String
    public let expiresAt: String
    
    public init(success: Bool, guestSessionId: String, expiresAt: String) {
        self.success = success
        self.guestSessionId = guestSessionId
        self.expiresAt = expiresAt
    }
}
