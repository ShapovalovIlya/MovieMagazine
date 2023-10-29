//
//  URLRequest.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation

extension URLRequest {
    mutating func addAcceptHeader() {
        self.addValue("application/json", forHTTPHeaderField: "accept")
    }
    
    mutating func addContentTypeHeader() {
        self.addValue("application/json", forHTTPHeaderField: "content-type")
    }
    
    mutating func addTokenHeader(_ bearer: Bearer) {
        self.addValue(bearer.token, forHTTPHeaderField: "Authorization")
    }
}
