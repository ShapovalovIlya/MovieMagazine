//
//  File.swift
//  
//
//  Created by Илья Шаповалов on 11.12.2023.
//

import Foundation

public extension Result where Success == Data, Failure == Error {
    func decode<T: Decodable>(_ type: T.Type, decoder: JSONDecoder) -> Result<T, Failure> {
        self.flatMap { data in
            Result<T, Failure> {
                try decoder.decode(T.self, from: data)
            }
        }
    }
}
