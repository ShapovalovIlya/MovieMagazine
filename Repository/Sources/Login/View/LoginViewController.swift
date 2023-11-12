//
//  LoginViewController.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 28.10.2023.
//

import Cocoa
import OSLog

public final class LoginViewController: NSViewController {
    private let loginView: LoginViewProtocol
    private let presenter: LoginPresenter
    private var logger: OSLog?
    
    //MARK: - init(_:)
    public init(
        loginView: LoginViewProtocol,
        presenter: LoginPresenter,
        logger: OSLog? = nil
    ) {
        self.loginView = loginView
        self.presenter = presenter
        self.logger = logger
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
        loginView.loginButton.action = #selector(loginButtonTap)
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
        self.loginView.loginTextField.stringValue = viewModel.loginField.value
        self.loginView.passwordTextField.stringValue = viewModel.passwordField.value
        log(event: #function)
    }
}

//MARK: - NSTextFieldDelegate
extension LoginViewController: NSTextFieldDelegate {
    public func controlTextDidChange(_ obj: Notification) {
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
    
    func log(event: String) {
        guard let logger else { return }
        os_log("LoginViewController:\t%@", log: logger, type: .debug, event)
    }
}

