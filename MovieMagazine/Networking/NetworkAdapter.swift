//
//  NetworkAdapter.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 01.11.2023.
//

import Foundation
import OSLog
import Endpoint
import NetworkService

struct NetworkAdapter {
    private let fetcher: NetworkFetcher
    private let coder: NetworkCoder
    
    //MARK: - init(_:)
    init(
        timeout: TimeInterval = .tenSeconds,
        keyCodingStrategy: NetworkCoder.KeyCodingStrategy = .convertSnakeCase,
        logger: OSLog? = nil
    ) {
        fetcher = .init(timeout: timeout, logger: logger)
        coder = .init(keyCodingStrategy: keyCodingStrategy)
    }
    
    //MARK: - Public methods
    func request<D: Decodable>(
        _ endpoint: TheMovieDB,
        payload: Data? = nil,
        resultCompletion: @escaping(Result<D, Error>) -> Void
    ) -> URLSessionDataTask {
        fetcher.perform(endpoint.makeRequest(), payload: payload) { result in
            let decodedResult: Result<D, Error> = coder.decode(result: result)
            resultCompletion(decodedResult)
        }
    }
    
}
