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
    private let router: AppRouter
    
    private(set) lazy var asObserver: Observer<Graph> = .init(
        queue: .main
    ) { /*[weak self]*/ graph in
  //      guard let self else { return .dead }
        self.process(graph)
        return .active
    }
    
    weak var delegate: RootPresenterDelegate?
    
    //MARK: - init(_:)
    init(
        store: GraphStore,
        router: AppRouter
    ) {
        self.store = store
        self.router = router
    }
    
    //MARK: - Public methods
    func windowDidLoad() {
        store.subscribe(asObserver)
    }
    
}

private extension RootPresenterImpl {
    func process(_ graph: Graph) {
        switch graph.loginStatus {
        case .none:
            router.showLoginView()
            
        case .inProgress: break
        case .success:
            router
            
        case .invalidCredentials: break
            
        case .error(let error):
            router.showError(error)
        }
    }
}
