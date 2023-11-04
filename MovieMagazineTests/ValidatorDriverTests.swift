//
//  ValidatorDriverTests.swift
//  MovieMagazineTests
//
//  Created by Шаповалов Илья on 02.11.2023.
//

import XCTest
@testable import MovieMagazine

final class ValidatorDriverTests: XCTestCase {
    private var sut: ValidatorDriver!
    private var graph: Graph!
    private var action: Action?
    
    override func setUp() {
        super.setUp()
        sut = .init(validator: .init())
        graph = Graph(state: .init()) { action in
            self.action = action
            }
    }
    
    override func tearDown() {
        sut = nil
        action = nil
        graph = nil
        
        super.tearDown()
    }
    
    func test_validateEmptyUsername() {
        let sut = ValidatorDriver(
            validator: .init(isEmpty: { _ in true })
        )
        graph.loginState.username = ""
        
        _ = sut.asObserver.observe(graph)
        
        let action = action as? LoginActions.ValidatedLogin
        XCTAssertEqual(action?.login, .empty)
    }
    
    func test_validateInvalidUsername() {
        let sut = ValidatorDriver(
            validator: .init(validateName: { _ in false })
        )
        graph.loginState.username = "Baz"
        
        _ = sut.asObserver.observe(graph)
        
        let action = action as? LoginActions.ValidatedLogin
        XCTAssertEqual(action?.login, .invalid("Baz"))
    }

}
