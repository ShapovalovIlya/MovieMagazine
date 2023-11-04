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
        get { graph.state.loginState.username.value }
        nonmutating set { graph.dispatch(LoginActions.UpdateLogin(login: newValue)) }
    }
    
    var isLoginValid: Bool { graph.state.loginState.username.isValid }
    
    var password: String {
        get { graph.state.loginState.password.value }
        nonmutating set { graph.dispatch(LoginActions.UpdatePassword(password: newValue)) }
    }
    
    var isPasswordValid: Bool { graph.state.loginState.password.isValid }
    
    var progress: LoginState.LoginStatus {
        get { graph.state.loginState.progress }
        nonmutating set { graph.dispatch(LoginActions.UpdateProgress(progress: newValue)) }
    }
    
    var isCredentialsValid: Bool { graph.state.loginState.isCredentialValid }
    
    func login() {
        graph.dispatch(LoginActions.LoginButtonTap())
    }
}
