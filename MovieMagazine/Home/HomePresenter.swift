//
//  HomePresenter.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 12.11.2023.
//

import Foundation
import Redux
import Core

protocol HomePresenter: AnyObject {
    func viewDidLoad()
    func viewDidAppear()
    func viewDidDisappear()
}

protocol HomePresenterDelegate: AnyObject {
    func render(_ viewModel: HomeViewModel)
}

final class HomePresenterImpl: HomePresenter {
    
    //MARK: - Private properties
    private let store: GraphStore
    private let router: AppRouter
    
    //MARK: - Public properties
    private(set) lazy var asObserver: Observer<Graph> = .init(
        queue: .main
    ) { [weak self] graph in
        guard let self else { return .dead }
        process(graph)
        return .active
    }
    
    weak var view: HomePresenterDelegate?
    
    //MARK: - init(_:)
    init(
        store: GraphStore,
        router: AppRouter
    ) {
        self.store = store
        self.router = router
    }
    
    //MARK: - Public methods
    func viewDidLoad() {
        store.subscribe(asObserver)
    }
    
    func viewDidAppear() {
        
    }
    
    func viewDidDisappear() {
        
    }
    
}

private extension HomePresenterImpl {
    func process(_ graph: Graph) {
        
    }
}
