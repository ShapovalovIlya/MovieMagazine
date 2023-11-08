//
//  TheMovieDB.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation
import SwiftFP

public struct TheMovieDB {
    typealias SetHeaders = (inout URLRequest) -> Void
    
    private let httpMethod: HTTPMethod
    private let path: String
    private let headers: SetHeaders
    private var queryItems: [URLQueryItem]
    
    //MARK: - URL
    private var url: URL {
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
    public func makeRequest(with body: Data? = nil) -> URLRequest {
        Box(url)
            .map(setupRequest)
            .map(setHttp(method: httpMethod))
            .map(addHeaders(headers))
            .map(addBody(body))
            .value
    }
    
    
    /// Create an intermediate request token that can be used to validate a TMDB user login. 
    /// - Parameter bearer: bearer api key
    public static func createRequestToken(_ bearer: Bearer) -> Self {
        .init(
            httpMethod: .GET,
            path: "authentication/token/new",
            headers: {
                $0.addAcceptHeader()
                $0.addTokenHeader(bearer)
            }
        )
    }
    
    //MARK: - Session
    public static func createSession(_ bearer: Bearer) -> Self {
        .init(
            httpMethod: .POST,
            path: "authentication/session/new",
            headers: {
                $0.addAcceptHeader()
                $0.addContentTypeHeader()
                $0.addTokenHeader(bearer)
            }
        )
    }
    
    
    /// This method allows an application to validate a request token by entering a username and password.
    /// - Parameter bearer: bearer api key
    public static func createSessionWithCredentials(_ bearer: Bearer) -> Self {
        .init(
            httpMethod: .POST,
            path: "authentication/token/validate_with_login",
            headers: {
                $0.addAcceptHeader()
                $0.addContentTypeHeader()
                $0.addTokenHeader(bearer)
            }
        )
    }
    
    /// Guest sessions are a special kind of session that give you some of the functionality of an account, but not all.
    /// For example, some of the things you can do with a guest session are; maintain a rated list, a watchlist and a favourite list.
    /// Guest sessions will automatically be deleted if they are not used within 60 minutes of it being issued.
    /// - Parameter bearer: bearer api key
    public static func createGuestSession(_ bearer: Bearer) -> Self {
        .init(
            httpMethod: .GET,
            path: "authentication/guest_session/new",
            headers: {
                $0.addAcceptHeader()
                $0.addTokenHeader(bearer)
            }
        )
    }
    
    public static func deleteSession(_ bearer: Bearer) -> Self {
        .init(
            httpMethod: .DELETE,
            path: "authentication/session",
            headers: {
                $0.addAcceptHeader()
                $0.addContentTypeHeader()
                $0.addTokenHeader(bearer)
            }
        )
    }
    
    //MARK: - Validation
    public static func validateKey(_ bearer: Bearer) -> Self {
        .init(
            httpMethod: .GET,
            path: "authentication",
            headers: {
                $0.addAcceptHeader()
                $0.addTokenHeader(bearer)
            }
        )
    }
    
    //MARK: - Account
    public static func details(
        for accountId: Int,
        sessionId: String,
        token bearer: Bearer
    ) -> Self {
        .init(
            httpMethod: .GET,
            path: ["account", accountId.description].joined(separator: "/"),
            headers: {
                $0.addAcceptHeader()
                $0.addTokenHeader(bearer)
            },
            queryItems: {
                URLQueryItem(name: "session_id", value: sessionId)
            }
        )
    }
    
    public static func addFavorite(
        for accountId: Int,
        sessionId: String,
        token bearer: Bearer
    ) -> Self {
        .init(
            httpMethod: .POST,
            path: ["account", accountId.description, "favorite"].joined(separator: "/"),
            headers: {
                $0.addAcceptHeader()
                $0.addContentTypeHeader()
                $0.addTokenHeader(bearer)
            },
            queryItems: {
                URLQueryItem(name: "session_id", value: sessionId)
            }
        )
    }
    
    //MARK: - Movies
    public  static func nowPlayingMovies(
        language: String = "en-US",
        page: Int,
        token bearer: Bearer
    ) -> Self {
        .getMovie(subPath: "now_playing", language: language, page: page, token: bearer)
    }
    
    public static func popularMovies(
        language: String = "en-US",
        page: Int,
        token bearer: Bearer
    ) -> Self {
        .getMovie(subPath: "popular", language: language, page: page, token: bearer)
    }
    
    public static func topRatedMovies(
        language: String = "en-US",
        page: Int,
        token bearer: Bearer
    ) -> Self {
        .getMovie(subPath: "top_rated", language: language, page: page, token: bearer)
    }
    
    public static func upcomingMovies(
        language: String = "en-US",
        page: Int,
        token bearer: Bearer
    ) -> Self {
        .getMovie(subPath: "upcoming", language: language, page: page, token: bearer)
    }

    
}

public extension TheMovieDB {
    enum HTTPMethod: String {
        case GET
        case POST
        case PUT
        case DELETE
    }
}

private extension TheMovieDB {
    static func getMovie(
        subPath: String,
        language: String,
        page: Int,
        token bearer: Bearer
    ) -> Self {
        .init(
            httpMethod: .GET,
            path: ["movie", subPath].joined(separator: "/"),
            headers: {
                $0.addAcceptHeader()
                $0.addTokenHeader(bearer)
            },
            queryItems: {
                URLQueryItem(name: "language", value: language)
                URLQueryItem(name: "page", value: page.description)
            }
        )

    }
    
    typealias Request = (URLRequest) -> URLRequest
    
    func addBody(_ data: Data?) -> Request {
        {
            guard let data else { return $0 }
            var request = $0
            request.httpBody = data
            return request
        }
    }
    
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
