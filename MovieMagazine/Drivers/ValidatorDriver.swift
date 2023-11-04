//
//  ValidatorDriver.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 04.11.2023.
//

import Foundation
import Validator
import OSLog

final class ValidatorDriver {
    //MARK: - Private properties
    private let validator: Validator
    private var storedUsername: String = .init()
    private var storedPassword: String = .init()
    private var logger: OSLog?
    
    //MARK: - Public properties
    private(set) lazy var asObserver: Observer<Graph> = .init(
        queue: .global()
    ) { [weak self] graph in
        guard let self else { return .dead }
        self.validateCredentials(graph)
        return .active
    }
    
    //MARK: - init(_:)
    init(
        validator: Validator = .live,
        logger: OSLog? = nil
    ) {
        self.validator = validator
        self.logger = logger
    }
}

private extension ValidatorDriver {
    //MARK: - Private methods
    func validateCredentials(_ graph: Graph) {
        guard 
            storedUsername != graph.loginState.username
            || storedPassword != graph.loginState.password
        else {
            return
        }
        storedUsername = graph.loginState.username
        storedPassword = graph.loginState.password
        logEvent()
        graph.dispatch(
            validate(username: graph.loginState.username),
            validate(password: graph.loginState.password)
        )
    }
    
    func validate(username: String) -> LoginActions.ValidatedLogin {
        if validator.isEmpty(username) {
            return LoginActions.ValidatedLogin(login: .empty)
        }
        return LoginActions.ValidatedLogin(
            login: validator.validateName(username)
            ? .valid(username)
            : .invalid(username)
        )
    }
    
    func validate(password: String) -> LoginActions.ValidatedPassword {
        if validator.isEmpty(password) {
            return LoginActions.ValidatedPassword(password: .empty)
        }
        return LoginActions.ValidatedPassword(
            password: validator.validatePassword(password)
            ? .valid(password)
            : .invalid(password)
        )
    }
    
    func logEvent() {
        guard let logger else { return }
        os_log(
            "ValidatorDriver: validate username: %@, password: %@",
            log: logger,
            type: .debug,
            storedUsername,
            storedPassword
        )
    }
}


