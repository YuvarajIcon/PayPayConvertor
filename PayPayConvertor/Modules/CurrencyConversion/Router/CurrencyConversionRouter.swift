//
//  CurrencyConversionRouter.swift
//  PayPayConvertor
//
//  Created by Yuvaraj Selvam on 13/01/24.
//

import Foundation
import UIKit

/**
 The router responsible for handling navigation in the currency conversion module.
 */
final class CurrencyConversionRouter: CurrencyConversionRouterProtocol {
/**
     Creates and configures the currency conversion module.
     
     - Returns: Configured UIViewController representing the currency conversion module.
     */
    static func createModule() -> UIViewController {
        let presenter = CurrencyConversionPresenter()
        let interactor = CurrencyConversionInteractor()
        let router = CurrencyConversionRouter()
        let controller = ConversionViewController(presenter: presenter)
        presenter.view = controller
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        return controller
    }
    
/**
     Navigates to the currency search screen.
     
     - Parameters:
       - navigationController: The navigation controller to perform the navigation.
       - delegate: The delegate to handle events in the currency search screen.
     */
    func navigateToSearch(with navigationController: UINavigationController, delegate: CurrencyChooserDelegate) {
        guard let searchController = CurrencySearchRouter.createModule() as? SearchViewController else {
            return
        }
        searchController.delegate = delegate
        navigationController.pushViewController(searchController, animated: true)
    }
}
