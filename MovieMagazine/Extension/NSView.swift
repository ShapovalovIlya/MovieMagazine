//
//  NSView.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 28.10.2023.
//

import Cocoa

extension NSView {
    func addSubviews(_ subviews: NSView...) {
        subviews.forEach(addSubview)
    }
}
