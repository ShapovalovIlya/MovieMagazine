//
//  Router.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 11.11.2023.
//

import Cocoa
import Core
import LoginModule
import HomeModule

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
        if checkIsPresented(LoginViewController.self) { return }
        let loginItem = assembly.makeLoginModule(router: self)
        splitViewController.splitViewItems = [loginItem]
    }
    
    func showHomeView() {
        let homeItem = assembly.makeHomeModule(router: self)
        splitViewController.splitViewItems = [homeItem]
    }
    
    func showError(_ error: Error, handler: @escaping (NSApplication.ModalResponse) -> Void) {
        guard let window = splitViewController.splitView.window else { return }
        let alert = assembly.makeAlert(.warning, title: "Oops!", info: error.localizedDescription)
        alert.beginSheetModal(for: window, completionHandler: handler)
//        splitViewController.presentError(error)
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
