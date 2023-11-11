//
//  GraphTests.swift
//  GraphTests
//
//  Created by Илья Шаповалов on 29.10.2023.
//

import XCTest
@testable import MovieMagazine

final class GraphTests: XCTestCase {
    private var sut: Graph!
    private var action: Action?
    
    override func setUp() {
        super.setUp()
        sut = Graph(state: .init()) { action in
            self.action = action
            }
    }
    
    override func tearDown() {
        sut = nil
        action = nil
        
        super.tearDown()
    }

    func test_graphDispatchCorrectAction() {
        sut.dispatch(MockAction())
        
        XCTAssertTrue(action is MockAction)
    }
    
    //MARK: - LoginViewNode
    func test_LoginNode_DispatchLogin() {
        sut.loginViewState.username = "Baz"
        
        let action = self.action as? LoginActions.UpdateLogin
        XCTAssertNotNil(action)
        XCTAssertEqual(action?.login, "Baz")
    }
    
    func test_LoginNode_DispatchPassword() {
        sut.loginViewState.password = "Baz"
        
        let action = self.action as? LoginActions.UpdatePassword
        XCTAssertNotNil(action)
        XCTAssertEqual(action?.password, "Baz")
    }
    
    func test_LoginNode_LoginAction() {
        sut.loginViewState.login()
        
        XCTAssertTrue(action is LoginActions.Login)
    }
    
    func test_LoginNode_CheckCredentialsValidState() {
        let mockLoginState = LoginViewState(
            email: .valid("Baz"),
            password: .valid("Baz")
        )
        sut = .init(
            state: .init(loginState: mockLoginState),
            dispatch: { _ in }
        )
        
        XCTAssertEqual(sut.loginViewState.username, "Baz")
        XCTAssertEqual(sut.loginViewState.password, "Baz")
        XCTAssertTrue(sut.loginState.isLoginValid)
        XCTAssertTrue(sut.loginState.isPasswordValid)
        XCTAssertTrue(sut.loginState.isCredentialsValid)
    }
    
    func test_LoginNode_CheckCredentialsInvalidState() {
        let mockLoginState = LoginViewState(
            email: .invalid("Baz"),
            password: .invalid("Baz")
        )
        sut = .init(
            state: .init(loginState: mockLoginState),
            dispatch: { _ in }
        )
        
        XCTAssertEqual(sut.loginViewState.username, "Baz")
        XCTAssertEqual(sut.loginViewState.password, "Baz")
        XCTAssertFalse(sut.loginState.isLoginValid)
        XCTAssertFalse(sut.loginState.isPasswordValid)
        XCTAssertFalse(sut.loginState.isCredentialsValid)
    }
    
    func test_LoginNode_CheckCredentialsEmptyState() {
        let mockLoginState = LoginViewState(
            email: .empty,
            password: .empty
        )
        sut = .init(
            state: .init(loginState: mockLoginState),
            dispatch: { _ in }
        )
        
        XCTAssertEqual(sut.loginViewState.username, "")
        XCTAssertEqual(sut.loginViewState.password, "")
        XCTAssertTrue(sut.loginState.isLoginValid)
        XCTAssertTrue(sut.loginState.isPasswordValid)
        XCTAssertFalse(sut.loginState.isCredentialsValid)
    }

}

private extension GraphTests {
    struct MockAction: Action {}
}
