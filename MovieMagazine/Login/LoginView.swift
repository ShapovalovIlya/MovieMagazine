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
}

final class LoginView: NSView, LoginViewProtocol {
    let loginTextField: NSTextField = {
        let textField = NSTextField()
        textField.tag = 200
        textField.isEditable = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField: NSTextField = {
        let textField = NSTextField()
        textField.tag = 201
        textField.isEditable = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    //MARK: - init(_:)
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        addSubviews(
            loginTextField,
            passwordTextField
        )
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

private extension LoginView {
    struct Drawing {
        static let textFieldWight: CGFloat = 200
        static let textFieldHeight: CGFloat = 30
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            loginTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
            loginTextField.widthAnchor.constraint(equalToConstant: Drawing.textFieldWight),
            loginTextField.heightAnchor.constraint(equalToConstant: Drawing.textFieldHeight),
            
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 10),
            passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalToConstant: Drawing.textFieldWight),
            passwordTextField.heightAnchor.constraint(equalToConstant: Drawing.textFieldHeight)
        ])
    }
}


