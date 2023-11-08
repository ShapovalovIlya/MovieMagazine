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
        do {
            let data = try encoder.encode(model)
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
    
    @inlinable
    public func decode<T: Decodable>(
        _ type: T.Type,
        from data: Data
    ) -> Result<T, Error> {
        do {
            let decoded = try decoder.decode(type, from: data)
            return .success(decoded)
        } catch {
            return .failure(error)
        }
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
