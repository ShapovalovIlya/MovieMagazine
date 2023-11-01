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
    
    public func perform(
        _ request: URLRequest,
        payload: Data? = nil,
        resultCompletion: @escaping ResultCompletion
    ) -> URLSessionDataTask {
        defer { log(event: request.description) }
        return Box(request)
            .map(addPayloadIfNeeded(payload))
            .map(logRequest)
            .flatMap(startTask(with: adapt(To: resultCompletion)))
    }

}

extension NetworkFetcher {
    @usableFromInline
    typealias Request = (URLRequest) -> URLRequest
    @usableFromInline
    typealias Response = (data: Data, response: URLResponse)
    @usableFromInline
    typealias DataTaskCompletion = (Data?, URLResponse?, Error?) -> Void
    
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
    
    @inlinable
    func logRequest(_ request: URLRequest) -> URLRequest {
        log(event: request.description)
        return request
    }
    
    @inlinable
    func startTask(
        with completion: @escaping DataTaskCompletion
    ) -> (URLRequest) -> URLSessionDataTask {
        { request in
            let task = session.dataTask(
                with: request,
                completionHandler: completion
            )
            task.resume()
            return task
        }
    }
    
    @inlinable
    func adapt(
        To resultCompletion: @escaping ResultCompletion
    ) -> DataTaskCompletion {
        { data, response, error in
            if let error = error {
                resultCompletion(.failure(error))
                return
            }
            guard let data, let response else {
                return
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
