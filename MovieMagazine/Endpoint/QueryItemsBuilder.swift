//
//  QueryItemsBuilder.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation

@resultBuilder
struct QueryItemsBuilder {
    static func buildBlock(_ components: [URLQueryItem]...) -> [URLQueryItem] {
        components.flatMap { $0 }
    }
    
    static func buildOptional(_ component: [URLQueryItem]?) -> [URLQueryItem] {
        component ?? .init()
    }
    
}
