//
//  RequestBuilder.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation

protocol RequestBuilder {
    func makeRequest() -> URLRequest
}

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}
