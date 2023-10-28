//
//  RootWindowController.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 28.10.2023.
//

import Cocoa

final class RootWindowController: NSWindowController {
    private let assembly: Assembly
    
    //MARK: - init(_:)
    init(
        assembly: Assembly,
        window: NSWindow
    ) {
        self.assembly = assembly
        super.init(window: window)
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
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
    }
    
    //MARK: - Public methods
    override func showWindow(_ sender: Any?) {
        window?.makeKeyAndOrderFront(sender)
        window?.center()
    }
    
    

}

private extension RootWindowController {
    
}
