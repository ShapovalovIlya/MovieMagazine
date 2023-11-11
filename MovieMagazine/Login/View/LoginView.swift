//
//  LoginView.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 28.10.2023.
//

import Cocoa

enum TextFieldType: Int {
    case loginTextField = 200
    case passwordTextField = 201
}

protocol LoginViewProtocol: NSView {
    var loginTextField: NSTextField { get }
    var passwordTextField: NSTextField { get }
    var loginButton: NSButton { get }
    var loginGuestButton: NSButton { get }
}

final class LoginView: NSView, LoginViewProtocol {
    let loginTextField: NSTextField = makeTextField(
        "Login",
        tag: .loginTextField
    )
    let passwordTextField: NSTextField = makeTextField(
        "Password",
        tag: .passwordTextField
    )
    let loginButton: NSButton = makeButton("Login")
    let loginGuestButton: NSButton = makeButton("Login as guest")
    
    //MARK: - init(_:)
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        addSubviews(
            loginTextField,
            passwordTextField,
            loginButton,
            loginGuestButton
        )
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension LoginView {
    static func makeTextField(_ placeholder: String, tag: TextFieldType) -> NSTextField {
        let textField = NSTextField()
        textField.tag = tag.rawValue
        textField.isEditable = true
        textField.placeholderString = placeholder
        textField.bezelStyle = .roundedBezel
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    static func makeButton(_ title: String) -> NSButton {
        let button = NSButton()
        button.setButtonType(.momentaryLight)
        button.title = title
        button.bezelStyle = .flexiblePush
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    struct Drawing {
        static let contentWight: CGFloat = 200
        static let contentHeight: CGFloat = 40
        static let contentSpacing: CGFloat = 10
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            //MARK: - loginTextField
            loginTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
            loginTextField.widthAnchor.constraint(equalToConstant: Drawing.contentWight),
            loginTextField.heightAnchor.constraint(equalToConstant: Drawing.contentHeight),
            
            //MARK: - passwordTextField
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: Drawing.contentSpacing),
            passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalToConstant: Drawing.contentWight),
            passwordTextField.heightAnchor.constraint(equalToConstant: Drawing.contentHeight),
            
            //MARK: - Login button
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: Drawing.contentSpacing),
            loginButton.widthAnchor.constraint(equalToConstant: Drawing.contentWight),
            loginButton.heightAnchor.constraint(equalToConstant: Drawing.contentHeight),
            
            //MARK: - Login guest button
            loginGuestButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginGuestButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: Drawing.contentSpacing),
            loginGuestButton.widthAnchor.constraint(equalToConstant: Drawing.contentWight),
            loginGuestButton.heightAnchor.constraint(equalToConstant: Drawing.contentHeight)
        ])
    }
}


