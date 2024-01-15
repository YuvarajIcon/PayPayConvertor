//
//  AppCoordinator.swift
//  PayPayConvertor
//
//  Created by Yuvaraj Selvam on 07/01/24.
//

import Foundation
import UIKit

/**
 AppCoordinator

 A coordinator responsible for managing the application's main flow and navigation.
 */
class AppCoordinator {
    var window: UIWindow
    var navigationController: UINavigationController?

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let rootViewController = CurrencyConversionRouter.createModule()
        navigationController = UINavigationController(rootViewController: rootViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        transitionWindow()
    }
    
    private func transitionWindow() {
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {}
    }
}
