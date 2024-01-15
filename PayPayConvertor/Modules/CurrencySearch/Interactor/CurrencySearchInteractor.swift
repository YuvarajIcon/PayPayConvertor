//
//  CurrencySearchInteractor.swift
//  PayPayConvertor
//
//  Created by Yuvaraj Selvam on 13/01/24.
//

import Foundation

/**
 The interactor responsible for handling currency search logic.
 */
final class CurrencySearchInteractor: CurrencySearchInteractorProtocol {
    weak var presenter: CurrencySearchInteractorOutputProtocol?
    
    /// Fetches the available currencies either from the local storage or the API.
    func fetchAvailableCurrencies() {
        guard let currencies = AvailableCurrencies.fetch() else {
            self.callAPI()
            return
        }
        if Date().timeIntervalSince(currencies.lastSyncedDate) >= 1800 {
            self.callAPI()
        } else {
            presenter?.didFetchCurrencies(with: currencies)
        }
    }
    
    private func callAPI() {
        APIService.shared.request(endPoint: ConversionEndpoint.currencies, model: AvailableCurrenciesDTO.self, errorModel: ErrorResponse.self, success: { [weak self] remote in
            guard let self else { return }
            guard let currencies = AvailableCurrencies.fetch() else {
                let currencies = AvailableCurrencies.create()
                currencies.update(with: remote)
                presenter?.didFetchCurrencies(with: currencies)
                return
            }
            currencies.update(with: remote)
            presenter?.didFetchCurrencies(with: currencies)
        }, failure: { [weak self] error, _ in
            guard let self else { return }
            presenter?.didFetchCurrenciesFailed(with: error)
        })
    }
}
