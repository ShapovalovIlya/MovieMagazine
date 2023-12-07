//
//  LoginViewNode.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation

public extension AppGraph {
    var loginViewState: LoginViewNode { .init(graph: self) }
}

public struct LoginViewNode: Equatable {
    private let graph: AppGraph
    
    init(graph: AppGraph) {
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
    
    public static func == (lhs: LoginViewNode, rhs: LoginViewNode) -> Bool {
        lhs.username == rhs.username
        && lhs.password == rhs.password
    }
}
