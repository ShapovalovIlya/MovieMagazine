//
//  NSWindow.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 28.10.2023.
//

import AppKit

public extension NSWindow {
    
    @inlinable
    @inline(__always)
    func addStyleMasks(_ styleMasks: StyleMask...) {
        styleMasks.forEach { styleMask.insert($0) }
    }
}
