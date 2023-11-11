//
//  TokenResponse.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 04.11.2023.
//

import Foundation

// "2023-11-04 20:57:51 UTC"

extension DateFormatter {
    static func formatIso(_ dateString: String) -> Date? {
        let timeZone = TimeZone(abbreviation: String(dateString.suffix(3)))
        let dateString = String(dateString.dropLast(4))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = timeZone
        return dateFormatter.date(from: dateString)
    }
}

public struct TokenResponse: Decodable {
    public let success: Bool
    public let expiresAt: String
    public let requestToken: String
    
    public init(success: Bool, expiresAt: String, requestToken: String) {
        self.success = success
        self.expiresAt = expiresAt
        self.requestToken = requestToken
    }
}

public struct TokenRequest: Encodable {
    public let username: String
    public let password: String
    public let requestToken: String
    
    public init(username: String, password: String, requestToken: String) {
        self.username = username
        self.password = password
        self.requestToken = requestToken
    }
}
