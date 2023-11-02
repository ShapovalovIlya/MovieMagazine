//
//  LoginPresenter.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import Foundation

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
    
    lazy var asObserver: Observer<Graph> = .init(queue: .main) { [weak self] graph in
        guard let self else {
            return .dead
        }
        delegate?.render(mapToProps(graph))
        return .active
        }

    weak var delegate: LoginViewDelegate?
    
    //MARK: - init(_:)
    init(store: GraphStore) {
        self.store = store
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
        .init(
            loginField: graph.loginState.username,
            isLoginValid: graph.loginState.isLoginValid,
            passwordField: graph.loginState.password,
            isPasswordValid: graph.loginState.isPasswordValid,
            isLoginButtonActive: graph.loginState.isCredentialsValid
        )
    }
}
