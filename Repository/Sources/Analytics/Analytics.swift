//
//  Analytics.swift
//
//
//  Created by Илья Шаповалов on 06.12.2023.
//

import Foundation
import OSLog

public protocol Analytics {
    func send(name: String, info: String...)
}

extension OSLog: Analytics {
    
    @inlinable
    @inline(__always)
    public func send(name: String, info: String...) {
        os_log("OS_Log:\t%@\t%@", log: self, type: .debug, name, info)
    }
    
}
