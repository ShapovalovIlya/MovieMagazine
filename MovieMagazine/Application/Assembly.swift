//
//  Assembly.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 28.10.2023.
//

import Cocoa

final class Assembly {
    private let store: Store
    
    init(store: Store) {
        self.store = store
    }
    
    func makeLoginViewController() -> NSViewController {
        let presenter = LoginPresenter(store: store)
        let viewController = LoginViewController(
            loginView: LoginView(frame: NSMakeRect(0, 0, 400, 400)),
            presenter: presenter
        )
        presenter.delegate = viewController
        return viewController
    }
    
    func makeRootWindow() -> NSWindow {
        let window = NSWindow()
        window.addStyleMasks(
            .closable,
            .miniaturizable,
            .resizable,
            .titled,
            .fullSizeContentView
        )
        return window
    }
}
