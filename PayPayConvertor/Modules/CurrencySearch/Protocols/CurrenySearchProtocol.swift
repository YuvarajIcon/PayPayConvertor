//
//  CurrenySearchProtocol.swift
//  PayPayConvertor
//
//  Created by Yuvaraj Selvam on 13/01/24.
//

import Foundation
import UIKit
import Alamofire

/**
 A protocol defining the interactions for the currency search view.
 */
protocol CurrencySearchViewProtocol: AnyObject {
    func dataDidLoad()
    func dataDidFail(with error: AFError)
}

/**
 A protocol defining the interactions for the currency search interactor.
 */
protocol CurrencySearchInteractorProtocol: AnyObject {
    var presenter: CurrencySearchInteractorOutputProtocol? { get set }
    func fetchAvailableCurrencies()
}

/**
 A protocol defining the output interactions for the currency search interactor.
 */
protocol CurrencySearchInteractorOutputProtocol: AnyObject {
    func didFetchCurrencies(with data: AvailableCurrencies)
    func didFetchCurrenciesFailed(with error: AFError)
}

/**
 A protocol defining the interactions for the currency search presenter.
 */
protocol CurrencySearchPresenterProtocol: AnyObject {
    var view: CurrencySearchViewProtocol? { get set }
    var interactor: CurrencySearchInteractorProtocol? { get set }
    var router: CurrencySearchRouterProtocol? { get set }
    var section: CurrencySection { get set }
    
    func getAvailableCurrencies()
}

/**
 A protocol defining the interactions for the currency search router.
 */
protocol CurrencySearchRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
}
