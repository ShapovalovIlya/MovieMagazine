//
//  AppDelegate.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 28.10.2023.
//

import Cocoa
import OSLog

final class AppDelegate: NSObject, NSApplicationDelegate {
    let store: Store
    let networkDriver: NetworkDriver
    
    override init() {
        self.store = Store(initial: AppState()) { state, action in
            os_log("Store", log: .system, type: .debug, String(describing: action))
            state.reduce(action)
        }
        self.networkDriver = .init(
            store: self.store,
            logger: .system
        )
        super.init()
        
        store.subscribe(networkDriver)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let assembly = Assembly(store: store)
        let rootWindowController = RootWindowController(
            assembly: assembly,
            window: assembly.makeRootWindow()
        )
        rootWindowController.showWindow(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    static func main() {
        let delegate = AppDelegate()
        let app = NSApplication.shared
        
        app.delegate = delegate
        app.run()
    }
}

private extension AppDelegate {

}

