//
//  RootPresenter.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 04.11.2023.
//

import Foundation
import Core
import ReduxCore

public protocol RootPresenter: AnyObject {
    func windowDidLoad()
}

public protocol RootPresenterDelegate: AnyObject {
    
}

public final class RootPresenterImpl: RootPresenter {
    private let store: AppStore
    private let router: AppRouter
    
    private(set) lazy var asObserver: Observer<AppGraph> = .init(
        queue: .main
    ) { /*[weak self]*/ graph in
  //      guard let self else { return .dead }
        self.process(graph)
        return .active
    }
    
    public weak var delegate: RootPresenterDelegate?
    
    //MARK: - init(_:)
    public init(
        store: AppStore,
        router: AppRouter
    ) {
        self.store = store
        self.router = router
    }
    
    //MARK: - Public methods
    public func windowDidLoad() {
        store.subscribe(asObserver)
    }
    
}

private extension RootPresenterImpl {
    func process(_ graph: AppGraph) {
        switch graph.state.loginStatus {
        case .none:
            router.showLoginView()
            
        case .inProgress: break
            
        case .success:
            router.showHomeView()
            
        case .invalidCredentials: break
            
        case .error(let error):
            handle(error)
        }
    }
    
    func handle(_ error: Error) {
        router.showError(error) { response in
            switch response {
            
            default: break
            }
        }
    }
}
