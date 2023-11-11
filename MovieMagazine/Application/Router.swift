//
//  Router.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 11.11.2023.
//

import Cocoa

protocol AppRouter: AnyObject {
    func showLoginView()
    func showHomeView()
    func showError(_ error: Error)
    func showLoading()
}

final class Router: AppRouter {
    private let splitViewController: NSSplitViewController
    private let assembly: AppAssembly
    
    //MARK: - init(_:)
    init(
        splitViewController: NSSplitViewController,
        assembly: AppAssembly
    ) {
        self.splitViewController = splitViewController
        self.assembly = assembly
    }
    
    //MARK: - Public methods
    func showLoginView() {
        if checkIsPresented(LoginViewController.self) {
            return
        }
        let loginItem = assembly.makeLoginModule(router: self)
        splitViewController.splitViewItems = [loginItem]
    }
    
    func showHomeView() {
        let homeItem = assembly.makeHomeModule(router: self)
        splitViewController.splitViewItems = [homeItem]
    }
    
    func showError(_ error: Error) {
        splitViewController.presentError(error)
    }
    
    func showLoading() {
        
    }
}

private extension Router {
    //MARK: - Private methods
    func checkIsPresented(_ someClass: AnyClass) -> Bool {
        splitViewController
            .splitViewItems
            .map(\.viewController)
            .contains { $0.isKind(of: someClass) }
    }
}
