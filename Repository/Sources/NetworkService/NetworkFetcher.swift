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
    public typealias ResultCompletion = (Result<Data, Error>) -> Void
    
    //MARK: - Private properties
    @usableFromInline let session: URLSession
    @usableFromInline let logger: OSLog?
    @usableFromInline let decoder: JSONDecoder
    
    //MARK: - init(_:)
    public init(
        timeout: TimeInterval = .tenSeconds,
        logger: OSLog? = nil
    ) {
        self.logger = logger
        let config = URLSessionConfiguration.background(withIdentifier: "NetworkFetcher")
        config.timeoutIntervalForRequest = timeout
        session = .init(configuration: config)
        decoder = .init()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    public func perform(
        _ request: URLRequest,
        payload: Data? = nil,
        resultCompletion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionDataTask {
        Box(request)
            .map(addPayloadIfNeeded(payload))
            .map(logRequest)
            .flatMap(startDataTask(with: adapt(to: resultCompletion)))
    }

}

extension NetworkFetcher {
    @usableFromInline
    typealias Request = (URLRequest) -> URLRequest
    @usableFromInline
    typealias Response = (data: Data, response: URLResponse)
    @usableFromInline
    typealias DataTaskResponse = (Data?, URLResponse?, Error?) -> Void
    
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
    func addPayloadIfNeeded(_ payload: Data?) -> Request {
        { request in
            guard let payload else {
                return request
            }
            var request = request
            request.httpBody = payload
            return request
        }
    }
    
    func adapt(to resultCompletion: @escaping ResultCompletion) -> DataTaskResponse {
        { data, response, error in
            if let error = error {
                resultCompletion(.failure(error))
                return
            }
            guard let data, let response else {
                preconditionFailure("No data and response in dataTaskResponse.")
            }
            resultCompletion(
                Result {
                    try Box(Response(data, response))
                        .map(parse(response:))
                        .value
                }
            )
        }
    }
    
    @inlinable
    func startDataTask(
        with completion: @escaping DataTaskResponse
    ) -> (URLRequest) -> URLSessionDataTask {
        { request in
            let task = session.dataTask(with: request, completionHandler: completion)
            task.resume()
            return task
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
    func logRequest(_ request: URLRequest) -> URLRequest {
        log(event: request.description)
        return request
    }
    
    @inlinable
    func log(event: String) {
        guard let logger = logger else {
            return
        }
        os_log("NetworkFetcher", log: logger, type: .debug, event)
    }
}
