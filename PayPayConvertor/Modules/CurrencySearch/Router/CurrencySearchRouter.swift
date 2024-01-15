//
//  CurrencySearchRouter.swift
//  PayPayConvertor
//
//  Created by Yuvaraj Selvam on 13/01/24.
//

import Foundation
import UIKit

/**
 The router responsible for currency search navigation.
 */
final class CurrencySearchRouter: CurrencySearchRouterProtocol {
/**
     Creates and returns the currency search module.
     
     - Returns: A UIViewController representing the currency search module.
     */
    static func createModule() -> UIViewController {
        let presenter = CurrencySearchPresenter()
        let interactor = CurrencySearchInteractor()
        let router = CurrencySearchRouter()
        let controller = SearchViewController(presenter: presenter)
        presenter.view = controller
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        return controller
    }
}
