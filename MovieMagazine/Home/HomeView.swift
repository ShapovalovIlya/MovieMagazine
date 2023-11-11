//
//  HomeView.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 12.11.2023.
//

import Cocoa

protocol HomeView: NSView {
    
}

final class HomeViewImpl: NSView, HomeView {
    
    //MARK: - init(_:)
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
