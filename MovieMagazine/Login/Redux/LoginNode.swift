//
//  LoginNode.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation

extension Graph {
    var loginState: LoginNode { .init(graph: self) }
}

struct LoginNode {
    private let graph: Graph
    
    init(graph: Graph) {
        self.graph = graph
    }
    
    var username: String {
        get { graph.state.loginState.username }
        nonmutating set { graph.dispatch(LoginActions.UpdateLogin(login: newValue)) }
    }
    
    var password: String {
        get { graph.state.loginState.password }
        nonmutating set { graph.dispatch(LoginActions.UpdatePassword(password: newValue)) }
    }
    
    func login() {
        graph.dispatch(LoginActions.Login())
    }
}
