//
//  Assembly.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 28.10.2023.
//

import Cocoa

final class Assembly {
    private let store: GraphStore
    
    init(store: GraphStore) {
        self.store = store
    }
    
    func makeLoginViewController() -> NSViewController {
        let presenter = LoginPresenter(store: store)
        store.subscribe(presenter.asObserver)
        let viewController = LoginViewController(
            loginView: LoginView(frame: NSMakeRect(0, 0, 400, 400)),
            presenter: presenter
        )
        presenter.delegate = viewController
        return viewController
    }
    
    func makeRootWindowController() -> NSWindowController {
        let presenter = RootPresenterImpl(store: store)
        self.store.subscribe(presenter.asObserver)
        let rootViewController = RootWindowController(
            assembly: self,
            window: makeRootWindow(), 
            presenter: presenter,
            logger: .viewCycle
        )
        presenter.view = rootViewController
        return rootViewController
    }
    
    
}

private extension Assembly {
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
