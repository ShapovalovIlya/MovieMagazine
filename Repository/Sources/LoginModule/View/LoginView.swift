//
//  LoginView.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 28.10.2023.
//

import Cocoa
import Core
import Extensions
import Design

enum TextFieldType: Int {
    case login = 200
    case password = 201
}

public protocol LoginViewProtocol: NSView {
    var loginTextField: NSTextField { get }
    var passwordTextField: NSSecureTextField { get }
    var loginButton: NSButton { get }
    var loginGuestButton: NSButton { get }
    
    func setLoginState(isValid: Bool)
    func setPasswordState(isValid: Bool)
}

public final class LoginView: NSView, LoginViewProtocol {
    public let loginTextField: NSTextField = makeLoginField()
    public let passwordTextField: NSSecureTextField = makePasswordField()
    public let loginButton: NSButton = makeButton("Login")
    public let loginGuestButton: NSButton = makeButton("Login as guest")
    
    //MARK: - init(_:)
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        configureLayer(for: loginTextField)
        configureLayer(for: passwordTextField)
        addSubviews(
            loginTextField,
            passwordTextField,
            loginButton,
            loginGuestButton
        )
        disableChildrenTAMIC()
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public methods
    public func setLoginState(isValid: Bool) {
        loginTextField.layer?.borderColor = setValidationColor(isValid)
    }
    
    public func setPasswordState(isValid: Bool) {
        passwordTextField.layer?.borderColor = setValidationColor(isValid)
    }
    
}

private extension LoginView {
    func setValidationColor(_ isValid: Bool) -> CGColor {
        isValid ? NSColor.lightGray.cgColor : NSColor.red.cgColor
    }
    
    func configureLayer(for view: NSView) {
        view.wantsLayer = true
        view.layer?.cornerRadius = Drawing.cornerRadius
        view.layer?.borderWidth = 1
        view.layer?.borderColor = NSColor.lightGray.cgColor
    }
    
    static func makeButton(_ title: String) -> NSButton {
        let button = NSButton()
        button.setButtonType(.momentaryLight)
        button.title = title
        button.bezelStyle = .flexiblePush
        return button
    }
    
    static func makeLoginField() -> NSTextField {
        let textField = NSTextField()
        
        textField.placeholderString = "Login"
        textField.tag = TextFieldType.login.rawValue
        textField.bezelStyle = .roundedBezel
        textField.focusRingType = .none
        return textField
    }
    
    static func makePasswordField() -> NSSecureTextField {
        let secureField = NSSecureTextField()
        secureField.placeholderString = "Password"
        secureField.bezelStyle = .roundedBezel
        secureField.tag = TextFieldType.password.rawValue
        secureField.focusRingType = .none
        return secureField
    }
    
    struct Drawing {
        static let contentWight: CGFloat = 200
        static let contentHeight: CGFloat = 40
        static let contentSpacing: CGFloat = 10
        static let cornerRadius: CGFloat = 10
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate {
            //MARK: - loginTextField
            loginTextField.centerXAnchor.constraint(equalTo: centerXAnchor)
            loginTextField.centerYAnchor.constraint(equalTo: centerYAnchor)
            loginTextField.widthAnchor.constraint(equalToConstant: Drawing.contentWight)
            loginTextField.heightAnchor.constraint(equalToConstant: Drawing.contentHeight)
            
            //MARK: - passwordTextField
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: Drawing.contentSpacing)
            passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor)
            passwordTextField.widthAnchor.constraint(equalToConstant: Drawing.contentWight)
            passwordTextField.heightAnchor.constraint(equalToConstant: Drawing.contentHeight)
            
            //MARK: - Login button
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor)
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: Drawing.contentSpacing)
            loginButton.widthAnchor.constraint(equalToConstant: Drawing.contentWight)
            loginButton.heightAnchor.constraint(equalToConstant: Drawing.contentHeight)
            
            //MARK: - Login guest button
            loginGuestButton.centerXAnchor.constraint(equalTo: centerXAnchor)
            loginGuestButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: Drawing.contentSpacing)
            loginGuestButton.widthAnchor.constraint(equalToConstant: Drawing.contentWight)
            loginGuestButton.heightAnchor.constraint(equalToConstant: Drawing.contentHeight)
        }
    }
}


