//
//  Movie.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 11.11.2023.
//

import Foundation

public struct Movie: Decodable {
    public let id: Int
    public let adult: Bool
    public let backdropPath: String
    public let genreIds: [Int]
    public let originalLanguage: String
    public let originalTitle: String
    public let overview: String
    public let popularity: Double
    public let posterPath: String
    public let releaseDate: String
    public let title: String
    public let video: Bool
    public let voteAverage: Double
    public let voteCount: Int

    public var identifier: ID {
        .init(id)
    }
    
    public init(
        id: Int,
        adult: Bool,
        backdropPath: String,
        genreIds: [Int],
        originalLanguage: String,
        originalTitle: String,
        overview: String,
        popularity: Double,
        posterPath: String,
        releaseDate: String,
        title: String,
        video: Bool,
        voteAverage: Double,
        voteCount: Int
    ) {
        self.id = id
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIds = genreIds
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}

public extension Movie {
    struct ID: Hashable {
        let value: Int
        
        init(_ value: Int) {
            self.value = value
        }
    }
}
