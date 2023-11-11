//
//  Dates.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 12.11.2023.
//

import Foundation

public struct Dates: Decodable {
    public let maximum: String
    public let minimum: String
    
    public init(
        maximum: String,
        minimum: String
    ) {
        self.maximum = maximum
        self.minimum = minimum
    }
}
