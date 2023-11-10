//
//  NetworkOperator.swift
//
//
//  Created by Илья Шаповалов on 05.11.2023.
//

import Foundation
import OSLog

public final class NetworkOperator {
    //MARK: - Private properties
    private let session: URLSession
    private let logger: OSLog?
    private var activeRequests: [UUID: (request: Request, task: URLSessionDataTask)] = .init()
    private var completedRequest: Set<UUID> = .init()
    
    //MARK: - Public properties
    public let queue: DispatchQueue
    
    //MARK: - init(_:)
    public init(
        config: URLSessionConfiguration = .default,
        queue: DispatchQueue = .init(label: "NetworkOperator"),
        logger: OSLog? = nil
    ) {
        session = URLSession(configuration: config)
        self.logger = logger
        self.queue = queue
    }
    
    //MARK: - Public methods
    public func process(@RequestBuilder requests: () -> [Request]) {
        var remainedActiveRequestIds = Set(activeRequests.keys)
        
        requests().forEach { request in
            process(request)
            remainedActiveRequestIds.remove(request.id)
        }
        remainedActiveRequestIds.forEach(cancel(requestId:))
    }
}

private extension NetworkOperator {
    //MARK: - Private methods
    func process(_ request: Request) {
        guard !completedRequest.contains(request.id) else { return }
        if activeRequests.keys.contains(request.id) {
            activeRequests[request.id]?.request = request
            return
        }
        log(request.request)
        let task = session.dataTask(
            with: request.request,
            completionHandler: complete(request)
        )
        activeRequests.updateValue((request, task), forKey: request.id)
        task.resume()
    }
    
    func complete(_ request: Request) -> (Data?, URLResponse?, Error?) -> Void {
        { [weak self] data, response, error in
            guard let self else { return }
            self.queue.async {
                guard let currentRequest = self.activeRequests.removeValue(forKey: request.id) else {
                    preconditionFailure("Request not found")
                }
                self.completedRequest.insert(request.id)
                if let error {
                    currentRequest.request.handler(.failure(error))
                }
                guard let data, let response else {
                    preconditionFailure("Result response not found")
                }
                currentRequest.request.handler(.success((data, response)))
            }
        }
    }
    
    func cancel(requestId: UUID) {
        guard let task = activeRequests[requestId]?.task else {
            preconditionFailure("Task not found")
        }
        task.cancel()
    }
    
    func log(_ request: URLRequest) {
        guard let logger else { return }
        os_log("NetworkOperator:\t start %@", log: logger, type: .debug, String(describing: request))
        guard
            let data = request.httpBody,
            let requestBody = String(data: data, encoding: .utf8)
        else {
            return
        }
        os_log("NetworkOperator:\t body %@", log: logger, type: .debug, requestBody)
    }
}
