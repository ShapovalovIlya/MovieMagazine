//
//  SessionNode.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 04.11.2023.
//

import Foundation

extension Graph {
    var sessionState: SessionNode { .init(graph: self) }
}

struct SessionNode {
    private let graph: Graph
    
    init(graph: Graph) {
        self.graph = graph
    }
    
    var requestToken: String {
        get { graph.state.sessionState.requestToken }
        nonmutating set { graph.dispatch(SessionActions.UpdateRequestToken(token: newValue)) }
    }
    
    var session: String { graph.state.sessionState.session.value }
    
    var expiresAt: String {
        get { graph.state.sessionState.expiresAt }
        nonmutating set { graph.dispatch(SessionActions.UpdateExpirationDate(expirationDate: newValue)) }
    }
}
