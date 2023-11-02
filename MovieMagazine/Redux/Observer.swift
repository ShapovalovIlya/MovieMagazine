//
//  Observer.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation

enum Status: Equatable {
    case active
    case dead
    case postponed(Int)
}

protocol Observer: AnyObject {
    var id: UUID { get }
    var queue: DispatchQueue { get }
    var observe: (Graph) -> Status { get }
}

extension Observer {
    var queue: DispatchQueue { .global(qos: .default) }
    
    func hash(into hasher: inout Hasher) {
        ObjectIdentifier(self).hash(into: &hasher)
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}
