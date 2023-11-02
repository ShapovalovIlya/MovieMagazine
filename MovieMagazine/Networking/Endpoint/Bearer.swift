//
//  Bearer.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation

struct Bearer {
    let token: String
    
    init(_ bearer: String) {
        self.token = ["Bearer", bearer].joined(separator: " ")
    }
}
