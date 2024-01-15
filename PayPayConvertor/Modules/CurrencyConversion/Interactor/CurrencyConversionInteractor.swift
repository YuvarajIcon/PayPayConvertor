//
//  CurrencyConversionInteractor.swift
//  PayPayConvertor
//
//  Created by Yuvaraj Selvam on 13/01/24.
//

import Foundation

/**
 The interactor responsible for handling currency conversion business logic.
 */
final class CurrencyConversionInteractor: CurrencyConversionInteractorProtocol {
    weak var presenter: CurrencyConversionInteractorOutputProtocol?
        
    /// Fetches exchange rates either from the local storage or the API.
    func fetchRates() {
        guard let rates = ExchangeRates.fetch() else {
            self.callAPI()
            return
        }
        if Date().timeIntervalSince(rates.lastSyncedDate) >= 1800 {
            self.callAPI()
        } else {
            presenter?.didFetchRates(with: rates)
        }
    }
    
    private func callAPI() {
        APIService.shared.request(endPoint: ConversionEndpoint.latest, model: ExchangeRatesDTO.self, errorModel: ErrorResponse.self, success: { [weak self] remote in
            guard let self else { return }
            guard let rate = ExchangeRates.fetch() else {
                let rate = ExchangeRates.create()
                rate.update(with: remote)
                presenter?.didFetchRates(with: rate)
                return
            }
            rate.update(with: remote)
            presenter?.didFetchRates(with: rate)
        }, failure: { [weak self] error, _ in
            guard let self else { return }
            presenter?.didFetchRatesFailed(with: error)
        })
    }
}
