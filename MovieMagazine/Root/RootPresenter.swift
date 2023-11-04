//
//  RootPresenter.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 04.11.2023.
//

import Foundation

protocol RootPresenter: AnyObject {
    func windowDidLoad()
}

protocol RootPresenterDelegate: AnyObject {
    
}

final class RootPresenterImpl: RootPresenter {
    private let store: GraphStore
    
    private(set) lazy var asObserver: Observer<Graph> = .init(
        queue: .main
    ) { [weak self] graph in
        guard let self else { return .dead }
        
        return .active
    }
    
    weak var view: RootPresenterDelegate?
    
    init(store: GraphStore) {
        self.store = store
    }
    
    func windowDidLoad() {
        
    }
    
}
