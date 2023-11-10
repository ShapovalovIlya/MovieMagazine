//
//  LoginPresenter.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation
import Validator

protocol LoginViewDelegate: AnyObject {
    func render(_ viewModel: LoginViewModel)
}

protocol LoginPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewDidDisappear()
    func loginDidChange(_ login: String)
    func passwordDidChange(_ password: String)
    func loginButtonDidTap()
}

final class LoginPresenter: LoginPresenterProtocol {
    private let store: GraphStore
    private let validator: Validator
    
    lazy var asObserver: Observer<Graph> = .init(queue: .main) { [weak self] graph in
        guard let self else {
            return .dead
        }
        delegate?.render(mapToProps(graph))
        return .active
        }

    weak var delegate: LoginViewDelegate?
    
    //MARK: - init(_:)
    init(
        store: GraphStore,
        validator: Validator = .live
    ) {
        self.store = store
        self.validator = validator
    }
    
    //MARK: - Public methods
    func viewDidLoad() {
        
    }
    
    func viewDidDisappear() {
        
    }
    
    func loginDidChange(_ login: String) {
        store.loginState.username = login
    }
    
    func passwordDidChange(_ password: String) {
        store.loginState.password = password
    }
    
    func loginButtonDidTap() {
        store.loginState.login()
    }
}

private extension LoginPresenter {
    func mapToProps(_ graph: Graph) -> LoginViewModel {
        return .init(
            loginField: validate(username: graph.loginState.username),
            passwordField: validate(password: graph.loginState.password)
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
