//
//  Observer.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 28.10.2023.
//

import Foundation

final class Observer<State> {
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

extension Observer: Equatable {
    static func == (lhs: Observer<State>, rhs: Observer<State>) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}

extension Observer: Hashable {
    func hash(into hasher: inout Hasher) {
        ObjectIdentifier(self).hash(into: &hasher)
    }
}

extension Observer {
    enum Status {
        case active
        case dead
        case postponed(Int)
    }
}
