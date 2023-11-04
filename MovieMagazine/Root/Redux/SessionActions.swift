//
//  SessionActions.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 04.11.2023.
//

import Foundation

enum SessionActions {
    struct UpdateRequestToken: Action {
        let token: String
    }
    
    struct UpdateExpirationDate: Action {
        let expirationDate: String
    }
}
