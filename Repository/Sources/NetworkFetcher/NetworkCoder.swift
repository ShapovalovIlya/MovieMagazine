//
//  NetworkCoder.swift
//  
//
//  Created by Шаповалов Илья on 01.11.2023.
//

import Foundation

public struct NetworkCoder {
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    public init() {
        decoder = .init()
        encoder = .init()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
    }
    
    func decode<T: Decodable>(_ data: Data) -> Result<T, Error> {
        do {
            let model = try decoder.decode(T.self, from: data)
            return .success(model)
        } catch {
            return .failure(error)
        }
    }
    
    func encode(_ model: Encodable) -> Result<Data, Error> {
        do {
            let data = try encoder.encode(model)
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
}
