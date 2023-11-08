//
//  File.swift
//  
//
//  Created by Илья Шаповалов on 05.11.2023.
//

import Foundation

public extension NetworkOperator {
    typealias Response = (data: Data, response: URLResponse)
    
    struct Request {
        public let id: UUID
        public let request: URLRequest
        public let handler: (Result<Response, Error>) -> Void
        
        public init(
            id: UUID,
            request: URLRequest,
            handler: @escaping (Result<Response, Error>) -> Void
        ) {
            self.id = id
            self.request = request
            self.handler = handler
        }
    }
}
