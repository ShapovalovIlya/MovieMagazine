//
//  AppActions.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 04.11.2023.
//

import Foundation
import Redux

public enum AppActions {
    public struct RaiseError: Action {
        public let error: Error
        
        public init(_ error: Error) {
            self.error = error
        }
    }
}
