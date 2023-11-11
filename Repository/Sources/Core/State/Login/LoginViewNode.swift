//
//  LoginViewNode.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation
import Redux

public extension Graph {
    var loginViewState: LoginViewNode { .init(graph: self) }
}

public struct LoginViewNode {
    private let graph: Graph
    
    init(graph: Graph) {
        self.graph = graph
    }
    
    public var username: String {
        get { graph.state.loginViewState.username }
        nonmutating set { graph.dispatch(LoginActions.UpdateLogin(newValue)) }
    }
    
    public var password: String {
        get { graph.state.loginViewState.password }
        nonmutating set { graph.dispatch(LoginActions.UpdatePassword(newValue)) }
    }
    
    public func login() {
        graph.dispatch(LoginActions.Login())
    }
}
