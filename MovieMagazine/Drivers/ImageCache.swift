//
//  ImageCache.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 05.11.2023.
//

import Foundation
import NetworkOperator
import Core

final class ImageCache {
    
    
    func observe(_ graph: AppGraph) {
        
    }
 
    func handler(for movieId: UUID) -> (Data?, URLResponse?, Error?) -> Void {
        { data, _, _ in
            
        }
    }
}
