//
//  SessionRequest.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 04.11.2023.
//

import Foundation

struct SessionRequest: Encodable {
    let requestToken: String
}

struct SessionResponse: Decodable {
    let success: Bool
    let sessionId: String
}

struct GuestSession: Decodable {
    let success: Bool
    let guestSessionId: String
    let expiresAt: String
}
