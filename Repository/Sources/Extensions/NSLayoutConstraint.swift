//
//  NSLayoutConstraint.swift
//
//
//  Created by Илья Шаповалов on 06.12.2023.
//

import AppKit

public extension NSLayoutConstraint {
    func assign(to other: inout NSLayoutConstraint) -> Self {
        other = self
        return self
    }
    
    static func activate(@ConstraintBuilder _ builder: () -> [NSLayoutConstraint]) {
        NSLayoutConstraint.activate(builder())
    }

    @resultBuilder
    struct ConstraintBuilder {
        public static func buildBlock(_ components: NSLayoutConstraint...) -> [NSLayoutConstraint] {
            components
        }
        
        public static func buildBlock(_ components: [NSLayoutConstraint]...) -> [NSLayoutConstraint] {
            components.flatMap { $0 }
        }
        
        public static func buildExpression(_ expression: NSLayoutConstraint) -> [NSLayoutConstraint] {
            [expression]
        }
        
        public static func buildArray(_ components: [[NSLayoutConstraint]]) -> [NSLayoutConstraint] {
            components.flatMap { $0 }
        }
        
        public static func buildOptional(_ component: [NSLayoutConstraint]?) -> [NSLayoutConstraint] {
            component ?? .init()
        }
        
        public static func buildEither(first component: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
            component
        }
        
        public static func buildEither(second component: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
            component
        }
        
        public static func buildPartialBlock(accumulated: [NSLayoutConstraint], next: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
            accumulated + next
        }
    }
}
