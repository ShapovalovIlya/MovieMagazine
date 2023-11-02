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
}

final class LoginView: NSView, LoginViewProtocol {
    let loginTextField: NSTextField = makeTextField("Login", tag: 200)
    let passwordTextField: NSTextField = makeTextField("Password", tag: 201)
    let loginButton: NSButton = makeButton("Login")
    
    //MARK: - init(_:)
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        addSubviews(
            loginTextField,
            passwordTextField,
            loginButton
        )
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

private extension LoginView {
    static func makeTextField(_ placeholder: String, tag: Int) -> NSTextField {
        let textField = NSTextField()
        textField.tag = tag
        textField.isEditable = true
        textField.placeholderString = placeholder
        textField.wantsLayer = true
        textField.bezelStyle = .roundedBezel
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    static func makeButton(_ title: String) -> NSButton {
        let button = NSButton()
        button.setButtonType(.momentaryLight)
        button.title = title
        button.wantsLayer = true
        button.bezelStyle = .push
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    struct Drawing {
        static let textFieldWight: CGFloat = 200
        static let textFieldHeight: CGFloat = 30
        static let contentSpacing: CGFloat = 10
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            loginTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
            loginTextField.widthAnchor.constraint(equalToConstant: Drawing.textFieldWight),
            loginTextField.heightAnchor.constraint(equalToConstant: Drawing.textFieldHeight),
            
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: Drawing.contentSpacing),
            passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalToConstant: Drawing.textFieldWight),
            passwordTextField.heightAnchor.constraint(equalToConstant: Drawing.textFieldHeight),
            
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: Drawing.contentSpacing),
            loginButton.widthAnchor.constraint(equalToConstant: Drawing.textFieldWight),
            loginButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}


