//
//  LoginViewController.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 28.10.2023.
//

import Cocoa
import Analytics
import Design

public final class LoginViewController: NSViewController {
    private let loginView: LoginViewProtocol
    private let presenter: LoginPresenter
    private var analytics: Analytics?
    
    //MARK: - init(_:)
    public init(
        loginView: LoginViewProtocol,
        presenter: LoginPresenter,
        analytics: Analytics? = nil
    ) {
        self.loginView = loginView
        self.presenter = presenter
        self.analytics = analytics
        super.init(nibName: nil, bundle: nil)
        log(event: #function)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    public override func loadView() {
        self.view = loginView
        setDelegate(self)
        log(event: #function)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        
        loginView.loginButton.target = self
        loginView.loginButton.action = #selector(Self.loginButtonTap)
        log(event: #function)
    }

    @objc func loginButtonTap() {
        presenter.loginButtonDidTap()
        log(event: #function)
    }
}

//MARK: - LoginViewDelegate
extension LoginViewController: LoginViewDelegate {
    public func render(_ viewModel: LoginViewModel) {
        loginView.loginTextField.stringValue = viewModel.loginField.value
        loginView.setLoginState(isValid: viewModel.loginField.isValid)
        loginView.passwordTextField.stringValue = viewModel.passwordField.value
        loginView.setPasswordState(isValid: viewModel.passwordField.isValid)
        loginView.loginButton.isEnabled = viewModel.isLoginButtonActive
        log(event: #function)
    }
}

//MARK: - NSTextFieldDelegate
extension LoginViewController: NSTextFieldDelegate {
    public func controlTextDidChange(_ obj: Notification) {
        guard let textField = obj.object as? NSTextField else { return }
        switch CredentialField.FieldType(rawValue: textField.tag) {
        case .login:
            presenter.loginDidChange(textField.stringValue)
            
        case .password:
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
    
    func log(event: String) {
        analytics?.send(name: "LoginViewController", info: event)
    }
}

