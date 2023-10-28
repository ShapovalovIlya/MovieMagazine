//
//  LoginPresenter.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation

protocol LoginViewDelegate: AnyObject {
    func render(_ viewModel: LoginViewController.LoginViewModel)
}

protocol LoginPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewDidDisappear()
    func loginDidChange(_ login: String)
    func passwordDidChange(_ password: String)
    func loginButtonDidTap()
}

final class LoginPresenter: LoginPresenterProtocol {
    private let store: Store
    private var asObserver: Observer<Graph> {
        Observer(queue: .main) { [weak self] graph in
            guard let self else {
                return .dead
            }
            delegate?.render(mapToProps(graph))
            return .active
        }
    }
    
    weak var delegate: LoginViewDelegate?
    
    //MARK: - init(_:)
    init(store: Store) {
        self.store = store
        store.subscribe(asObserver)
    }
    
    //MARK: - Public methods
    func viewDidLoad() {
        
    }
    
    func viewDidDisappear() {
        
    }
    
    func loginDidChange(_ login: String) {
        store.graph.dispatch(LoginActions.Login(value: login))
    }
    
    func passwordDidChange(_ password: String) {
        store.graph.dispatch(LoginActions.Password(value: password))
    }
    
    func loginButtonDidTap() {
        store.graph.dispatch(LoginActions.LoginButtonTap())
    }
}

private extension LoginPresenter {
    func mapToProps(_ graph: Graph) -> LoginViewController.LoginViewModel {
        .init(
            loginField: graph.loginState.username.value,
            isLoginValid: graph.loginState.username.isValid,
            passwordField: graph.loginState.password.value,
            isPasswordValid: graph.loginState.password.isValid,
            isLoginButtonActive: graph.loginState.isCredentialsValid
        )
    }
}
