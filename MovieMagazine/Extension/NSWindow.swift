//
//  NSWindow.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 28.10.2023.
//

import Cocoa

extension NSWindow {
    func addStyleMasks(_ styleMasks: StyleMask...) {
        styleMasks.forEach { styleMask.insert($0) }
    }
}
