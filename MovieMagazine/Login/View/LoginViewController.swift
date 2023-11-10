//
//  LoginViewController.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 28.10.2023.
//

import Cocoa

final class LoginViewController: NSViewController {
    private let loginView: LoginViewProtocol
    private let presenter: LoginPresenterProtocol
    
    //MARK: - init(_:)
    init(
        loginView: LoginViewProtocol,
        presenter: LoginPresenterProtocol
    ) {
        self.loginView = loginView
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    override func loadView() {
        self.view = loginView
        setDelegate(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        loginView.loginButton.target = self
        loginView.loginButton.action = #selector(loginButtonTap)
    }

    @objc func loginButtonTap() {
        presenter.loginButtonDidTap()
    }
}

//MARK: - LoginViewDelegate
extension LoginViewController: LoginViewDelegate {
    func render(_ viewModel: LoginViewModel) {
        print("render!")
        self.loginView.loginTextField.stringValue = viewModel.loginField.value
        self.loginView.passwordTextField.stringValue = viewModel.passwordField.value
    }
}

//MARK: - NSTextFieldDelegate
extension LoginViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        guard let textField = obj.object as? NSTextField else { return }
        switch TextFieldType(rawValue: textField.tag) {
        case .loginTextField:
            presenter.loginDidChange(textField.stringValue)
            
        case .passwordTextField:
            presenter.passwordDidChange(textField.stringValue)
            
        default: break
        }
    }
    
}

private extension LoginViewController {
    func setDelegate(_ obj: NSTextFieldDelegate) {
        loginView.loginTextField.delegate = obj
        loginView.passwordTextField.delegate = obj
    }
}

