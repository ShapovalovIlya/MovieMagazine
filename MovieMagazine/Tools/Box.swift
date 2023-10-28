//
//  Box.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation

struct Box<T> {
    let value: T
    
    init(_ value: T) {
        self.value = value
    }
    
    func map<U>(_ transform: (T) throws -> U) rethrows -> Box<U> {
        try Box<U>(transform(value))
    }
    
    func flatMap<U>(_ transform: (T) throws -> U) rethrows -> U {
        try transform(self.value)
    }
}
