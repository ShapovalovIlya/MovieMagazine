//
//  AppActions.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 04.11.2023.
//

import Foundation

enum AppActions {
    struct RaiseError: Action {
        let error: Error
    }
}
