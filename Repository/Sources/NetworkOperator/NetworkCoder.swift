//
//  NetworkCoder.swift
//
//
//  Created by Илья Шаповалов on 01.11.2023.
//

import Foundation

public struct NetworkCoder {
    @usableFromInline let decoder: JSONDecoder
    @usableFromInline let encoder: JSONEncoder
    
    public init(
        keyCodingStrategy: KeyCodingStrategy = .convertSnakeCase
    ) {
        decoder = .init()
        encoder = .init()
        
        decoder.keyDecodingStrategy = keyCodingStrategy.decoder
        encoder.keyEncodingStrategy = keyCodingStrategy.encoder
    }
    
    @inlinable
    public func decode<T: Decodable>(
        _ type: T.Type,
        from result: Result<Data, Error>
    ) -> Result<T, Error> {
        switch result {
        case .success(let success):
            return decode(type.self, from: success)
        case .failure(let failure):
            return .failure(failure)
        }
    }
    
    @inlinable
    public func encode(_ builder: @escaping () -> Encodable) -> Result<Data, Error> {
        encode(builder())
    }
    
    @inlinable
    public func encode(_ model: Encodable) -> Result<Data, Error> {
        Result { try encoder.encode(model) }
    }
    
    @inlinable
    public func decode<T: Decodable>(
        _ type: T.Type,
        from data: Data
    ) -> Result<T, Error> {
        Result { try decoder.decode(type, from: data) }
    }
}

public extension NetworkCoder {
    enum KeyCodingStrategy {
        case convertSnakeCase
        case useDefaultKeys
        
        var decoder: JSONDecoder.KeyDecodingStrategy {
            switch self {
            case .convertSnakeCase: return .convertFromSnakeCase
            case .useDefaultKeys: return .useDefaultKeys
            }
        }
        
        var encoder: JSONEncoder.KeyEncodingStrategy {
            switch self {
            case .convertSnakeCase: return .convertToSnakeCase
            case .useDefaultKeys: return .useDefaultKeys
            }
        }
    }
}
