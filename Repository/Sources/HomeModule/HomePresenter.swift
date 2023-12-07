//
//  HomePresenter.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 12.11.2023.
//

import Foundation
import ReduxCore
import Core

public protocol HomePresenter: AnyObject {
    func viewDidLoad()
    func viewDidAppear()
    func viewDidDisappear()
}

public protocol HomePresenterDelegate: AnyObject {
    func render(_ viewModel: HomeViewModel)
}

public final class HomePresenterImpl: HomePresenter {
    
    //MARK: - Private properties
    private let store: AppStore
    private let router: AppRouter
    
    //MARK: - Public properties
    private(set) lazy var asObserver: Observer<AppGraph> = .init(
        queue: .main
    ) { [weak self] graph in
        guard let self else { return .dead }
        process(graph)
        return .active
    }
    
    public weak var view: HomePresenterDelegate?
    
    //MARK: - init(_:)
    public init(
        store: AppStore,
        router: AppRouter
    ) {
        self.store = store
        self.router = router
    }
    
    //MARK: - Public methods
    public func viewDidLoad() {
        store.subscribe(asObserver)
    }
    
    public func viewDidAppear() {
        
    }
    
    public func viewDidDisappear() {
        
    }
    
}

private extension HomePresenterImpl {
    func process(_ graph: AppGraph) {
        
    }
}
