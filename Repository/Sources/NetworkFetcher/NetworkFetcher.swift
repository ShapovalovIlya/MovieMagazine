//
//  NetworkFetcher.swift
//
//
//  Created by Илья Шаповалов on 30.10.2023.
//

import Foundation
import OSLog
import SwiftFP

public struct NetworkFetcher {
    //MARK: - Private properties
    private let session: URLSession
    @usableFromInline let logger: OSLog?
    @usableFromInline let decoder: JSONDecoder
    
    //MARK: - init(_:)
    init(
        timeout: TimeInterval,
        logger: OSLog? = nil
    ) {
        self.logger = logger
        let config = URLSessionConfiguration.background(withIdentifier: "NetworkFetcher")
        config.timeoutIntervalForRequest = timeout
        session = .init(configuration: config)
        decoder = .init()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    public func perform<T: Codable>(
        _ request: URLRequest,
        payload: Data? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionDataTask {
        defer { log(event: request.description) }
        var request = request
        if let payload = payload {
            request.httpBody = payload
        }
        return session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard
                let data = data,
                let response = response
            else {
                return
            }
            completion(
                Result {
                    try Box(Response(data, response))
                        .map(parse(response:))
                        .map(decode(type: T.self, decoder: decoder))
                        .value
                }
            )
        }
    }

}

extension NetworkFetcher {
    @usableFromInline
    typealias Response = (data: Data, response: URLResponse)
    
    @usableFromInline
    enum StatusCodes: Int {
        case success = 200
        case badRequest = 400
        case unauthorized = 401
        case forbidden = 402
        case notFound = 404
        case methodNotAllowed = 405
    }
    
    @inlinable
    func decode<T: Decodable>(type: T.Type, decoder: JSONDecoder) -> (Data) throws -> T {
        { data in
            try decoder.decode(type, from: data)
        }
    }
    
    @inlinable
    func parse(response: Response) throws -> Data {
        try parse(URLResponse: response.response)
        return response.data
    }
    
    @inlinable
    func parse(URLResponse: URLResponse) throws {
        guard let httpResponse = URLResponse as? HTTPURLResponse else { return }
        
        switch StatusCodes(rawValue: httpResponse.statusCode) {
        case .success: return
        case .badRequest: throw URLError(.badServerResponse)
        case .unauthorized: throw URLError(.badServerResponse)
        case .forbidden: throw URLError(.badServerResponse)
        case .notFound: throw URLError(.badServerResponse)
        case .methodNotAllowed: throw URLError(.badServerResponse)
        default: throw URLError(.badServerResponse)
        }
    }
    
    @inlinable
    func log(event: String) {
        guard let logger = logger else {
            return
        }
        os_log("NetworkFetcher", log: logger, type: .debug, event)
    }
}
