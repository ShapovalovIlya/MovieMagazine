//
//  RequestBuilder.swift
//
//
//  Created by Илья Шаповалов on 05.11.2023.
//

import Foundation

@resultBuilder
public struct RequestBuilder {
    public static func buildBlock(_ components: [NetworkOperator.Request]...) -> [NetworkOperator.Request] {
        components.flatMap { $0 }
    }
    
    public static func buildOptional(_ component: [NetworkOperator.Request]?) -> [NetworkOperator.Request] {
        component ?? []
    }
    
    public static func buildExpression(_ expression: NetworkOperator.Request) -> [NetworkOperator.Request] {
        [expression]
    }
    
    public static func buildEither(first component: [NetworkOperator.Request]) -> [NetworkOperator.Request] {
        component
    }
    
    public static func buildEither(second component: [NetworkOperator.Request]) -> [NetworkOperator.Request] {
        component
    }
}
