//
//  AppActions.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 04.11.2023.
//

import Foundation
import Core

enum AppActions {
    struct RaiseError: Action {
        let error: Error
    }
}
