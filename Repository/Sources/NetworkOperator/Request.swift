//
//  File.swift
//  
//
//  Created by Илья Шаповалов on 05.11.2023.
//

import Foundation

public extension NetworkOperator {
    struct Request {
        public let id: UUID
        public let request: URLRequest
        public let handler: (Data?, URLResponse?, Error?) -> Void
        
        public init(
            id: UUID,
            request: URLRequest,
            handler: @escaping (Data?, URLResponse?, Error?) -> Void
        ) {
            self.id = id
            self.request = request
            self.handler = handler
        }
    }
}
