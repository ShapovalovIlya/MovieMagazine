//
//  Observer.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation

final class Observer<State> {
    let id: UUID = .init()
    let queue: DispatchQueue
    let observe: (State) -> Status
    
    init(
        queue: DispatchQueue,
        observe: @escaping (State) -> Status
    ) {
        self.queue = queue
        self.observe = observe
    }
}

extension Observer {
    enum Status: Equatable {
        case active
        case dead
        case postponed(Int)
    }
}

extension Observer: Hashable {
    func hash(into hasher: inout Hasher) {
        ObjectIdentifier(self).hash(into: &hasher)
    }
}

extension Observer: Equatable {
    static func ==(lhs: Observer, rhs: Observer) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}
