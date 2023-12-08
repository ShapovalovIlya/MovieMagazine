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

final class AppDelegate: NSObject {
    //MARK: - Properties
    let analytics: Analytics
    let store: AppStore
    
    //MARK: - init(_:)
    override init() {
        self.analytics = OSLog.system
        self.store = Store(initial: AppState()) { state, action in
            NSLog("Store:\t%@", String(describing: action))
//            os_log("Store:\t%@", log: .system, type: .debug, String(describing: action))
            state.reduce(action)
        }
        super.init()
        
        store.subscribe {
            SessionDriver(analytics: OSLog.system).asObserver
            NetworkDriver(analytics: OSLog.system).asObserver
        }
        
        log(event: #function)
    }
    
    //MARK: - main
    static func main() {
        let delegate = AppDelegate()
        let app = NSApplication.shared
        
        app.delegate = delegate
        app.run()
    }
}
 
//MARK: - NSApplicationDelegate
extension AppDelegate: NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let assembly = Assembly(store: store)
        let router = assembly.makeRouter()
        let rootWindowController = assembly.makeRootWindow(router: router)
        rootWindowController.showWindow(nil)
        
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        
    }
    
    func applicationDidResignActive(_ notification: Notification) {
        
    }
    
    func applicationDidHide(_ notification: Notification) {
        
    }
    
    func applicationDidUnhide(_ notification: Notification) {
        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        
        return true
    }
    
    func application(_ application: NSApplication, open urls: [URL]) {
        log(event: #function)
    }
    
    func application(_ application: NSApplication, didReceiveRemoteNotification userInfo: [String : Any]) {
        log(event: #function)
    }
    
}

private extension AppDelegate {
    func log(event: String) {
        analytics.send(name: "AppDelegate", info: event)
    }
}

