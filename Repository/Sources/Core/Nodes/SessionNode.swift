//
//  SessionNode.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 04.11.2023.
//

import Foundation

public extension AppGraph {
    var sessionState: SessionNode { .init(graph: self) }
}

public struct SessionNode {
    private let graph: AppGraph
    
    init(graph: AppGraph) {
        self.graph = graph
    }
    
    public var requestToken: String {
        get { graph.state.sessionState.requestToken }
//        nonmutating set { graph.dispatch(SessionActions.ReceiveToken(token: newValue)) }
    }
    
    public var session: String { graph.state.sessionState.session.value }
    
    public var expiresAt: String {
        get { graph.state.sessionState.expiresAt }
//        nonmutating set { graph.dispatch(SessionActions.UpdateExpirationDate(expirationDate: newValue)) }
    }
}
