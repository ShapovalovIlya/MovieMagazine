//
//  OSLog.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 01.11.2023.
//

import Foundation
import OSLog

extension OSLog {
    static let system = OSLog(
        subsystem: Bundle.main.bundleIdentifier!,
        category: "System"
    )
    
    static let viewCycle = OSLog(
        subsystem: Bundle.main.bundleIdentifier!,
        category: "ViewCycle"
    )
}
