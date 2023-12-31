//
//  RootWindowController.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 28.10.2023.
//

import Cocoa
import Analytics

public final class RootWindowController: NSWindowController {
    //MARK: - Private properties
    private let analytics: Analytics?
    private let presenter: RootPresenter
    
    //MARK: - init(_:)
    public init(
        window: NSWindow,
        presenter: RootPresenter,
        analytics: Analytics? = nil
    ) {
        self.presenter = presenter
        self.analytics = analytics
        super.init(window: window)
        
        log(event: #function)
        
        self.loadWindow()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    public override func loadWindow() {
        window?.windowController = self
        
        log(event: #function)
        windowDidLoad()
    }
    
    public override func windowDidLoad() {
        super.windowDidLoad()
        
        presenter.windowDidLoad()
        log(event: #function)
    }
    
    //MARK: - Public methods
    public override func showWindow(_ sender: Any?) {
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
        analytics?.send(name: "RootWindowController", info: event)
    }
}
