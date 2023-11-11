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
        let loginItem = assembly.makeLoginModule(router: self)
        splitViewController.addSplitViewItem(loginItem)
    }
    
    func showHomeView() {
        let homeItem = assembly.makeHomeModule(router: self)
        splitViewController.addSplitViewItem(homeItem)
    }
    
    func showError(_ error: Error) {
        splitViewController.presentError(error)
    }
    
    func showLoading() {
        
    }
}
