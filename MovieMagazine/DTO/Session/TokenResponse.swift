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

struct TokenResponse: Decodable {
    let success: Bool
    let expiresAt: String
    let requestToken: String
}

struct TokenRequest: Encodable {
    let username: String
    let password: String
    let requestToken: String
}
