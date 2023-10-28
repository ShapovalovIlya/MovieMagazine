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
    
    var username: LoginState.CredentialStatus {
        get { graph.state.loginState.email }
        nonmutating set {  }
    }
    
    var password: LoginState.CredentialStatus {
        get { graph.state.loginState.password }
        nonmutating set { }
    }
    
    var progress: LoginState.LoginStatus { graph.state.loginState.progress }
    var isCredentialsValid: Bool { graph.state.loginState.isCredentialValid }
}
