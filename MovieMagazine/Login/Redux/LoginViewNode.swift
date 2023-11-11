//
//  LoginViewNode.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation

extension Graph {
    var loginViewState: LoginViewNode { .init(graph: self) }
}

struct LoginViewNode {
    private let graph: Graph
    
    init(graph: Graph) {
        self.graph = graph
    }
    
    var username: String {
        get { graph.state.loginViewState.username }
        nonmutating set { graph.dispatch(LoginActions.UpdateLogin(login: newValue)) }
    }
    
    var password: String {
        get { graph.state.loginViewState.password }
        nonmutating set { graph.dispatch(LoginActions.UpdatePassword(password: newValue)) }
    }
    
    func login() {
        graph.dispatch(LoginActions.Login())
    }
}
