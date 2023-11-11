//
//  HomeViewController.swift
//  MovieMagazine
//
//  Created by Илья Шаповалов on 12.11.2023.
//

import Cocoa
import OSLog

final class HomeViewController: NSViewController {
    private let presenter: HomePresenter
    private let homeView: HomeView
    private var logger: OSLog?

    //MARK: - init(_:)
    init(
        presenter: HomePresenter,
        homeView: HomeView,
        logger: OSLog? = nil
    ) {
        self.presenter = presenter
        self.homeView = homeView
        self.logger = logger
        super.init(nibName: nil, bundle: nil)
        log(event: #function)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life cycle
    override func loadView() {
        view = homeView
        
        log(event: #function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        log(event: #function)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        presenter.viewDidAppear()
        log(event: #function)
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        presenter.viewDidDisappear()
        log(event: #function)
    }
    
}

extension HomeViewController: HomePresenterDelegate {
    func render(_ viewModel: HomeViewModel) {
        
    }
}

private extension HomeViewController {
    func log(event: String) {
        guard let logger else { return }
        os_log("HomeViewController:\t%@", log: logger, type: .debug, event)
    }
}
