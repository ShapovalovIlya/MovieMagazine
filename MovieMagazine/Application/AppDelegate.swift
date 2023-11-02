//
//  AppDelegate.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 28.10.2023.
//

import Cocoa
import OSLog

final class AppDelegate: NSObject, NSApplicationDelegate {
    let store: GraphStore
    let networkDriver: NetworkDriver
    
    //MARK: - init(_:)
    override init() {
        self.store = .init {
            Store(initial: AppState()) { state, action in
                print("Store: \(String(describing: action))")
    //            os_log("Store", log: .system, type: .debug, String(describing: action))
                state.reduce(action)
            }
        }
        self.networkDriver = .init(
            store: self.store,
            logger: .system
        )
        super.init()
        
        store.subscribe(networkDriver.asObserver)
    }

    //MARK: - Public methods
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let assembly = Assembly(store: store)
        let rootWindowController = RootWindowController(
            assembly: assembly,
            window: assembly.makeRootWindow()
        )
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

