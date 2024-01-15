//
//  CurrencyConversionProtocol.swift
//  PayPayConvertor
//
//  Created by Yuvaraj Selvam on 13/01/24.
//

import Foundation
import UIKit
import Alamofire

/**
 A protocol defining the interactions for the currency conversion view.
 */
protocol CurrencyConversionViewProtocol: AnyObject {
    func dataDidLoad()
    func dataDidFail(with error: AFError)
}

/**
 A protocol defining the interactions for the currency conversion interactor.
 */
protocol CurrencyConversionInteractorProtocol: AnyObject {
    var presenter: CurrencyConversionInteractorOutputProtocol? { get set }
    func fetchRates()
}

/**
 A protocol defining the output interactions for the currency conversion interactor.
 */
protocol CurrencyConversionInteractorOutputProtocol: AnyObject {
    func didFetchRates(with data: ExchangeRates)
    func didFetchRatesFailed(with error: AFError)
}

/**
 A protocol defining the interactions for the currency conversion presenter.
 */
protocol CurrencyConversionPresenterProtocol: AnyObject {
    var view: CurrencyConversionViewProtocol? { get set }
    var interactor: CurrencyConversionInteractorProtocol? { get set }
    var router: CurrencyConversionRouterProtocol? { get set }
    var section: ConversionSection { get set }
    
    func getRates(for value: Double?)
    func moveToSearch(with navigationController: UINavigationController, delegate: CurrencyChooserDelegate)
}

/**
 A protocol defining the interactions for the currency conversion router.
 */
protocol CurrencyConversionRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func navigateToSearch(with navigationController: UINavigationController, delegate: CurrencyChooserDelegate)
}
