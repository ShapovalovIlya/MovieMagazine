//
//  LoginPresenter.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation
import Validator
import Redux
import Core

public protocol LoginViewDelegate: AnyObject {
    func render(_ viewModel: LoginViewModel)
}

public protocol LoginPresenter: AnyObject {
    func viewDidLoad()
    func viewDidDisappear()
    func loginDidChange(_ login: String)
    func passwordDidChange(_ password: String)
    func loginButtonDidTap()
}

public final class LoginPresenterImpl: LoginPresenter {
    private let store: GraphStore
    private let validator: Validator
    private let router: AppRouter
    
    private(set) lazy var asObserver: Observer<Graph> = .init(
        queue: .main
    ) { [weak self] graph in
        guard let self else { return .dead }
        delegate?.render(mapToProps(graph))
        return .active
    }

    public weak var delegate: LoginViewDelegate?
    
    //MARK: - init(_:)
    public init(
        store: GraphStore,
        router: AppRouter,
        validator: Validator
    ) {
        self.store = store
        self.router = router
        self.validator = validator
    }
    
    //MARK: - Public methods
    public func viewDidLoad() {
        store.subscribe(asObserver)
    }
    
    public func viewDidDisappear() {
        
    }
    
    public func loginDidChange(_ login: String) {
        store.loginViewState.username = login
    }
    
    public func passwordDidChange(_ password: String) {
        store.loginViewState.password = password
    }
    
    public func loginButtonDidTap() {
        store.loginViewState.login()
    }
}

private extension LoginPresenterImpl {
    func mapToProps(_ graph: Graph) -> LoginViewModel {
        return .init(
            loginField: validate(username: graph.loginViewState.username),
            passwordField: validate(password: graph.loginViewState.password)
        )
    }
    
    func validate(username: String) -> LoginViewModel.FieldState {
        if validator.isEmpty(username) {
            return .empty
        }
        if validator.validateName(username) {
            return .valid(username)
        }
        return .invalid(username)
    }
    
    func validate(password: String) -> LoginViewModel.FieldState {
        if validator.isEmpty(password) {
            return .empty
        }
        if validator.validatePassword(password) {
            return .valid(password)
        }
        return .invalid(password)
    }
}
