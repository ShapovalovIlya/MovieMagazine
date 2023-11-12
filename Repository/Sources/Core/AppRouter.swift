//
//  AppRouter.swift
//  
//
//  Created by Илья Шаповалов on 12.11.2023.
//

import Cocoa

public protocol AppRouter: AnyObject {
    func showLoginView()
    func showHomeView()
    func showError(_ error: Error, handler: @escaping (NSApplication.ModalResponse) -> Void)
    func showLoading()
}
