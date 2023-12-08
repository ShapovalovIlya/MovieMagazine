//
//  NSView.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 28.10.2023.
//

import AppKit

public extension NSView {
    
    @inlinable
    @inline(__always)
    func addSubviews(_ subviews: NSView...) {
        subviews.forEach(addSubview)
    }
    
    @inlinable
    @inline(__always)
    func disableChildrenTAMIC() {
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
