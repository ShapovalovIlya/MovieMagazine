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
    let validatorDriver: ValidatorDriver
    
    //MARK: - init(_:)
    override init() {
        self.store = .init {
            Store(initial: AppState()) { state, action in
                os_log(
                    "Store %@",
                    log: .system,
                    type: .debug,
                    String(describing: action)
                )
                state.reduce(action)
            }
        }
        self.networkDriver = .init(logger: .system)
        self.validatorDriver = .init(logger: .system)
        super.init()
        
        store.subscribe(networkDriver.asObserver)
        store.subscribe(validatorDriver.asObserver)
    }

    //MARK: - Public methods
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let assembly = Assembly(store: store)
        let rootWindowController = assembly.makeRootWindowController()
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

