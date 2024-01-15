//
//  CurrencyConversionPresenter.swift
//  PayPayConvertor
//
//  Created by Yuvaraj Selvam on 13/01/24.
//

import Foundation
import Alamofire
import UIKit

struct ConversionSection: Hashable {
    let rows: [ConversionRow]
}

struct ConversionRow: Hashable {
    let currencyCode: String
    let value: Double
    
    func contains(_ filter: String?) -> Bool {
        guard let filterText = filter else { return true }
        if filterText.isEmpty { return true }
        let lowercasedFilter = filterText.lowercased()
        return currencyCode.lowercased().contains(lowercasedFilter)
    }
}

/**
 The presenter responsible for handling currency conversion presentation logic.
 */
final class CurrencyConversionPresenter: CurrencyConversionPresenterProtocol {
    weak var view: CurrencyConversionViewProtocol?
    var interactor: CurrencyConversionInteractorProtocol?
    var router: CurrencyConversionRouterProtocol?
    var section: ConversionSection = ConversionSection(rows: [])
    
    private var baseValue: Double = 1
    
    /// Gets the exchange rates for the specified value.
    func getRates(for value: Double? = nil) {
        if let value {
            baseValue = value
        }
        interactor?.fetchRates()
    }
    
    /// Moves to the currency search screen.
    func moveToSearch(with navigationController: UINavigationController, delegate: CurrencyChooserDelegate) {
        router?.navigateToSearch(with: navigationController, delegate: delegate)
    }
    
    private func generateRows(with dto: ExchangeRatesDTO) {
        guard let currency = Preference.shared.currency else { return }
        var rows: [ConversionRow] = []
        for rate in dto.rates.rates {
            let convertedValue = convertCurrency(
                amount: baseValue,
                from: currency,
                to: rate.key,
                exRates: dto
            )
            let formattedValue = Double(String(format: "%.4f", convertedValue))
            guard let formattedValue else { continue }
            rows.append(ConversionRow(currencyCode: rate.key, value: formattedValue))
        }
        self.section = ConversionSection(rows: rows)
    }
    
    private func convertCurrency(amount: Double, from fromCurrency: String, to toCurrency: String, exRates: ExchangeRatesDTO) -> Double {
        let rates = exRates.rates.rates
        let fromRate = rates.first(where: { $0.key == fromCurrency })?.value.asDouble ?? 1
        let toRate = rates.first(where: { $0.key == toCurrency })?.value.asDouble ?? 1
        let convertedAmount = amount * (toRate / fromRate)
        return convertedAmount
    }
}

//MARK: CurrencyConversionInteractorOutputProtocol Extension
extension CurrencyConversionPresenter: CurrencyConversionInteractorOutputProtocol {
    func didFetchRates(with data: ExchangeRates) {
        let rateDTO = ExchangeRatesDTO(
            disclaimer: data.disclaimer,
            license: data.license,
            timestamp: Int(data.timestamp),
            base: data.base,
            rates: RatesDTO(rates: Array(data.rates))
        )
        generateRows(with: rateDTO)
        view?.dataDidLoad()
    }
    
    func didFetchRatesFailed(with error: AFError) {
        view?.dataDidFail(with: error)
    }
}
