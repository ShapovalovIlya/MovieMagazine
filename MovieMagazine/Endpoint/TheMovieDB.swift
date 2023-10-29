//
//  TheMovieDB.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation

struct TheMovieDB: RequestBuilder {
    typealias SetHeaders = (inout URLRequest) -> Void
    
    private let httpMethod: HTTPMethod
    private let path: String
    private let headers: SetHeaders
    private var queryItems: [URLQueryItem]
    
    //MARK: - URL
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = ["/3/", path].joined()
        
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            preconditionFailure("Unable to create url from: \(components)")
        }
        
        return url
    }
    
    //MARK: - init(_:)
    private init(
        httpMethod: HTTPMethod,
        path: String,
        headers: @escaping SetHeaders,
        @QueryItemsBuilder queryItems: () -> [URLQueryItem] = { .init() }
    ) {
        self.httpMethod = httpMethod
        self.path = path
        self.headers = headers
        self.queryItems = queryItems()
    }
    
    //MARK: - Public methods
    func makeRequest() -> URLRequest {
        Box(url)
            .map(setupRequest)
            .map(setHttp(method: httpMethod))
            .map(addHeaders(headers))
            .value
    }
    
    static func createRequestToken(token bearer: String) -> Self {
        .init(
            httpMethod: .GET,
            path: "authentication/token/new",
            headers: {
                $0.addValue("accept", forHTTPHeaderField: "application/json")
                $0.addValue("Authorization", forHTTPHeaderField: ["Bearer", bearer].joined(separator: " "))
            })
    }
}

private extension TheMovieDB {
    typealias Request = (URLRequest) -> URLRequest
    
    func addHeaders(_ headers: @escaping SetHeaders) -> Request {
        {
            var request = $0
            headers(&request)
            return request
        }
    }
    
    func setHttp(method: HTTPMethod) -> (URLRequest) -> URLRequest {
        {
            var request = $0
            request.httpMethod = method.rawValue
            return request
        }
    }
    
    func setupRequest(_ url: URL) -> URLRequest {
        .init(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10
        )
    }
}
