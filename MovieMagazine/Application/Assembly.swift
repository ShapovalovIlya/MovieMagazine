//
//  Assembly.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 28.10.2023.
//

import Cocoa
import Core
import LoginModule
import HomeModule
import Extensions
import RootModule
import Analytics
import OSLog

protocol AppAssembly: AnyObject {
    func makeLoginModule(router: AppRouter) -> NSSplitViewItem
    func makeHomeModule(router: AppRouter) -> NSSplitViewItem
    func loadingScreen() -> NSProgressIndicator
    func makeAlert(_ style: NSAlert.Style, title: String, info: String) -> NSAlert
}

final class Assembly: AppAssembly {
    private let store: AppStore
    private let splitViewController = NSSplitViewController()
    
    private struct Drawing {
        static let detailRect = NSMakeRect(0, 0, 400, 400)
        static let sideBarRect = NSMakeRect(0, 0, 200, 400)
        static let progressRect = NSMakeRect(0, 0, 100, 100)
    }
    
    //MARK: - init(_:)
    init(store: AppStore) {
        self.store = store
    }
    
    //MARK: - Public methods
    func makeRouter() -> Router {
        Router(
            splitViewController: splitViewController,
            assembly: self
        )
    }
    
    //MARK: - Screens view
    func makeHomeModule(router: AppRouter) -> NSSplitViewItem {
        let presenter = HomePresenterImpl(
            store: store,
            router: router
        )
        let viewController = HomeViewController(
            presenter: presenter,
            homeView: HomeViewImpl(frame: Drawing.detailRect),
            logger: .viewCycle
        )
        presenter.view = viewController
        return NSSplitViewItem(viewController: viewController)
    }
    
    func makeLoginModule(router: AppRouter) -> NSSplitViewItem {
        let presenter = LoginPresenterImpl(
            store: store,
            router: router,
            validator: .live
        )
        let viewController = LoginViewController(
            loginView: LoginView(frame: Drawing.detailRect),
            presenter: presenter,
            analytics: OSLog.viewCycle
        )
        presenter.delegate = viewController
        return NSSplitViewItem(viewController: viewController)
    }
    
    func makeRootWindow(router: AppRouter) -> NSWindowController {
        let presenter = RootPresenterImpl(store: store, router: router)
        let rootViewController = RootWindowController(
            window: makeRootWindow(),
            presenter: presenter,
            analytics: OSLog.viewCycle
        )
        presenter.delegate = rootViewController
        rootViewController.contentViewController = splitViewController
        rootViewController.window?.contentView = splitViewController.splitView
        return rootViewController
    }
    
    func makeAlert(
        _ style: NSAlert.Style = .warning,
        title: String,
        info: String = .init()
    ) -> NSAlert {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = info
        alert.alertStyle = style
        return alert
    }
    
    //MARK: - Utility views
    func loadingScreen() -> NSProgressIndicator {
        let progress = NSProgressIndicator()
        progress.style = .spinning
        progress.usesThreadedAnimation = true
        progress.frame = Drawing.progressRect
        progress.startAnimation(nil)
        return progress
    }
    
}

private extension Assembly {
    func makeRootWindow() -> NSWindow {
        let window = NSWindow()
        window.title = "Movie magazine"
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
