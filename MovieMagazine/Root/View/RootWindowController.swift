//
//  RootWindowController.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 28.10.2023.
//

import Cocoa
import OSLog

final class RootWindowController: NSWindowController {
    //MARK: - Private properties
    private let assembly: Assembly
    private let logger: OSLog?
    private let presenter: RootPresenter
    
    //MARK: - init(_:)
    init(
        assembly: Assembly,
        window: NSWindow,
        presenter: RootPresenter,
        logger: OSLog? = nil
    ) {
        self.assembly = assembly
        self.presenter = presenter
        self.logger = logger
        super.init(window: window)
        
        log(event: #function)
        
        self.loadWindow()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    override func loadWindow() {
        window?.windowController = self
        
        let viewController = assembly.makeLoginViewController()
        self.contentViewController = viewController
        self.window?.contentView = viewController.view
        
        log(event: #function)
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        presenter.windowDidLoad()
        log(event: #function)
    }
    
    //MARK: - Public methods
    override func showWindow(_ sender: Any?) {
        window?.orderFrontRegardless()
        window?.center()
        log(event: #function)
    }
    
    

}

//MARK: - RootPresenterDelegate
extension RootWindowController: RootPresenterDelegate {
    
}

private extension RootWindowController {
    //MARK: - Private methods
    func log(event: String) {
        guard let logger else { return }
            os_log("RootWindowController %@", log: logger, type: .debug, event)
    }
}
