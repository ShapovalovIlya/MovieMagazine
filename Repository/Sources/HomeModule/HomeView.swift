//
//  HomeView.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 12.11.2023.
//

import Cocoa
import Extensions

public protocol HomeView: NSView {
    
}

public final class HomeViewImpl: NSView, HomeView {
    
    //MARK: - init(_:)
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
