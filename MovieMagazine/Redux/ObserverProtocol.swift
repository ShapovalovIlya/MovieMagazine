//
//  ObserverProtocol.swift
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

protocol ObserverP: AnyObject, Equatable, Hashable {
    associatedtype ID: Hashable
    associatedtype State
    
    var id: ID { get }
    var queue: DispatchQueue { get }
    
    func observe(_ state: State) -> Status
}

extension ObserverP {
    var queue: DispatchQueue { .global(qos: .default) }
    
    func hash(into hasher: inout Hasher) {
        ObjectIdentifier(self).hash(into: &hasher)
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}
