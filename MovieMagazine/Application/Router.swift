//
//  Router.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 11.11.2023.
//

import Cocoa

protocol AppRouter: AnyObject {
    func showLoginView()
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
        let loginItem = assembly.makeLoginViewController(router: self)
        splitViewController.addSplitViewItem(loginItem)
        splitViewController.title = "Login"
    }
}
