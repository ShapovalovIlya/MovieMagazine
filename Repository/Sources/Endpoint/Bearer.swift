//
//  Bearer.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation

public struct Bearer {
    let token: String
    
    public init(_ bearer: String) {
        self.token = ["Bearer", bearer].joined(separator: " ")
    }
}
