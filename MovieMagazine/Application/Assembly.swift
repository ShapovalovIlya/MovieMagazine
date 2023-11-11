//
//  Assembly.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 28.10.2023.
//

import Cocoa

protocol AppAssembly: AnyObject {
    func makeLoginViewController(router: AppRouter) -> NSSplitViewItem
}

final class Assembly: AppAssembly {
    private let store: GraphStore
    private let splitViewController = NSSplitViewController()
    
    //MARK: - init(_:)
    init(store: GraphStore) {
        self.store = store
    }
    
    //MARK: - Public methods
    func makeRouter() -> Router {
        Router(
            splitViewController: splitViewController,
            assembly: self
        )
    }
    
    func makeLoginViewController(router: AppRouter) -> NSSplitViewItem {
        let presenter = LoginPresenter(
            store: store,
            router: router,
            validator: .live
        )
        store.subscribe(presenter.asObserver)
        let viewController = LoginViewController(
            loginView: LoginView(frame: NSMakeRect(0, 0, 400, 400)),
            presenter: presenter,
            logger: .viewCycle
        )
        presenter.delegate = viewController
        return NSSplitViewItem(viewController: viewController)
    }
    
    func makeRootWindowController(router: AppRouter) -> NSWindowController {
        let presenter = RootPresenterImpl(store: store, router: router)
        self.store.subscribe(presenter.asObserver)
        let rootViewController = RootWindowController(
            window: makeRootWindow(), 
            presenter: presenter,
            logger: .viewCycle
        )
        presenter.view = rootViewController
        rootViewController.contentViewController = splitViewController
        rootViewController.window?.contentView = splitViewController.splitView
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
