//
//  NetworkDriver.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation
import Analytics
import Endpoint
import NetworkOperator
import ReduxCore
import Core

typealias ResultCompletion = (Result<NetworkOperator.Response, Error>) -> Void

final class NetworkDriver {
    private let networkOperator: NetworkOperator
    private let networkCoder: NetworkCoder
    private let queue: DispatchQueue = .init(label: "NetworkDriver")
    private let bearer: Bearer = .init(ApiKeys.bearer)
    private var analytics: Analytics?
    
    private(set) lazy var asObserver: Observer<AppGraph> = .init(
        queue: queue,
        observe: process(_:)
    )
    
    //MARK: - init(_:)
    init(analytics: Analytics? = nil) {
        self.analytics = analytics
        networkOperator = .init(queue: self.queue)
        networkCoder = .init(keyCodingStrategy: .convertSnakeCase)
        log(event: #function)
    }
    
    deinit {
        log(event: #function)
    }
}

private extension NetworkDriver {
    
    func process(_ graph: AppGraph) -> AppObserver.Status {
        networkOperator.process {
        }
        return .active
    }
    
    func request(
        _ endpoint: TheMovieDB,
        id: UUID = .init(),
        data: Data? = nil,
        handler: @escaping ResultCompletion
    ) -> NetworkOperator.Request {
        return .init(
            id: id,
            request: endpoint.makeRequest(with: data),
            handler: handler
        )
    }
    
    
    func log(event: String) {
        analytics?.send(name: "NetworkDriver", info: event)
    }
}
