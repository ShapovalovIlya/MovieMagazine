//
//  AppDelegate.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 28.10.2023.
//

import Cocoa
import OSLog
import Core

final class AppDelegate: NSObject, NSApplicationDelegate {
    let store: GraphStore
    let networkDriver: NetworkDriver
    let sessionDriver: SessionDriver
    
    //MARK: - init(_:)
    override init() {
        self.store = .init {
            Store(initial: AppState()) { state, action in
                os_log(
                    "Store:\t%@",
                    log: .system,
                    type: .debug,
                    String(describing: action)
                )
                state.reduce(action)
            }
        }
        self.networkDriver = .init(logger: .system)
        self.sessionDriver = .init(logger: .system)
        super.init()
        
        store.subscribe(networkDriver.asObserver)
        store.subscribe(sessionDriver.asObserver)
    }

    //MARK: - Public methods
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let assembly = Assembly(store: store)
        let router = assembly.makeRouter()
        let rootWindowController = assembly.makeRootWindowController(router: router)
        rootWindowController.showWindow(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    //MARK: - main
    static func main() {
        let delegate = AppDelegate()
        let app = NSApplication.shared
        
        app.delegate = delegate
        app.run()
    }
}

private extension AppDelegate {
}

