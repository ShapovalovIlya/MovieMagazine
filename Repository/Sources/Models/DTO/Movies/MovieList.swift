//
//  MovieList.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 11.11.2023.
//

import Foundation

public struct MovieList: Decodable {
    public let dates: Dates
    public let page: Int
    public let results: [Movie]
    public let totalPages: Int
    public let totalResults: Int
    
    public init(
        dates: Dates,
        page: Int,
        results: [Movie],
        totalPages: Int,
        totalResults: Int
    ) {
        self.dates = dates
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}
