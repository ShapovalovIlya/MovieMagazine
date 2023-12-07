//
//  AppDelegate.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 28.10.2023.
//

import Cocoa
import ReduxCore
import Core
import Analytics
import OSLog

final class AppDelegate: NSObject, NSApplicationDelegate {
    let store: AppStore
    
    //MARK: - init(_:)
    override init() {
        self.store = Store(initial: AppState()) { state, action in
            os_log(
                "Store:\t%@",
                log: .system,
                type: .debug,
                String(describing: action)
            )
            state.reduce(action)
        }
        super.init()
        
        store.subscribe {
            SessionDriver(analytics: OSLog.system).asObserver
            NetworkDriver(analytics: OSLog.system).asObserver
        }
        
    }

    //MARK: - Public methods
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let assembly = Assembly(store: store)
        let router = assembly.makeRouter()
        let rootWindowController = assembly.makeRootWindow(router: router)
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

