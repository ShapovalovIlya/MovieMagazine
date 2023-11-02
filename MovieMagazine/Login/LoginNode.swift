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
    let graph: Graph
    
    var username: String {
        get { graph.state.loginState.email.value }
        nonmutating set { graph.dispatch(LoginActions.Login(value: newValue)) }
    }
    
    var isLoginValid: Bool { graph.state.loginState.email.isValid }
    
    var password: String {
        get { graph.state.loginState.password.value }
        nonmutating set { graph.dispatch(LoginActions.Password(value: newValue)) }
    }
    
    var isPasswordValid: Bool { graph.state.loginState.password.isValid }
    
    var progress: LoginState.LoginStatus {
        get { graph.state.loginState.progress }
        nonmutating set { }
    }
    
    var isCredentialsValid: Bool { graph.state.loginState.isCredentialValid }
    
    func login() {
        graph.dispatch(LoginActions.LoginButtonTap())
    }
}
