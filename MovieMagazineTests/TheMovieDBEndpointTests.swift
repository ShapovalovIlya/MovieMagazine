//
//  TheMovieDBEndpointTests.swift
//  MovieMagazineTests
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import XCTest
@testable import MovieMagazine

final class TheMovieDBEndpointTests: XCTestCase {

    func test_nowPlayingMovies() {
        let sut = TheMovieDB.nowPlayingMovies(page: 1, token: .init("Baz"))
        
        XCTAssertEqual(
            sut.makeRequest().url?.absoluteString,
            "https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=1"
        )
    }
    
    func test_popularMovies() {
        let sut = TheMovieDB.popularMovies(page: 1, token: .init("Baz"))
        
        XCTAssertEqual(
            sut.makeRequest().url?.absoluteString,
            "https://api.themoviedb.org/3/movie/popular?language=en-US&page=1"
        )
    }
    
    func test_topRatedMovies() {
        let sut = TheMovieDB.topRatedMovies(page: 1, token: .init("Baz"))
        
        XCTAssertEqual(
            sut.makeRequest().url?.absoluteString,
            "https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1"
        )
    }
    
    func test_upcomingMovies() {
        let sut = TheMovieDB.upcomingMovies(page: 1, token: .init("Baz"))
        
        XCTAssertEqual(
            sut.makeRequest().url?.absoluteString,
            "https://api.themoviedb.org/3/movie/upcoming?language=en-US&page=1"
        )
    }
    
    func test_sessionWithCredentials() {
        let sut = TheMovieDB.createSessionWithCredentials(token: .init("Baz"))
        
        XCTAssertEqual(
            sut.makeRequest().url?.absoluteString,
            "https://api.themoviedb.org/3/authentication/token/validate_with_login"
        )
    }

}
