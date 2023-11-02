//
//  File.swift
//  
//
//  Created by Илья Шаповалов on 30.10.2023.
//

import Foundation

public struct Box<T> {
    public let value: T
    
    public init(_ value: T) {
        self.value = value
    }
    
    public func map<U>(_ transform: (T) throws -> U) rethrows -> Box<U> {
        try Box<U>(transform(value))
    }
    
    public func flatMap<U>(_ transform: (T) throws -> U) rethrows -> U {
        try transform(self.value)
    }
}
