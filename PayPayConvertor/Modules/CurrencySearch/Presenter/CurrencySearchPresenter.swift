//
//  CurrencySearchPresenter.swift
//  PayPayConvertor
//
//  Created by Yuvaraj Selvam on 13/01/24.
//

import Foundation
import Alamofire

struct CurrencySection: Hashable {
    let rows: [CurrencyRow]
}

struct CurrencyRow: Hashable {
    let code: String
    let fullName: String
    
    func contains(_ filter: String?) -> Bool {
        guard let filterText = filter else { return true }
        if filterText.isEmpty { return true }
        let lowercasedFilter = filterText.lowercased()
        let value = code + fullName
        return value.lowercased().contains(lowercasedFilter)
    }
}

/**
 The presenter responsible for handling currency search presentation logic.
 */
final class CurrencySearchPresenter: CurrencySearchPresenterProtocol {
    weak var view: CurrencySearchViewProtocol?
    var interactor: CurrencySearchInteractorProtocol?
    var router: CurrencySearchRouterProtocol?
    var section: CurrencySection = CurrencySection(rows: [])
    
    /// Gets the available currencies.
    func getAvailableCurrencies() {
        interactor?.fetchAvailableCurrencies()
    }
    
    private func generateRows(with dto: AvailableCurrenciesDTO) {
        var rows: [CurrencyRow] = []
        for currency in dto.currencies {
            guard let value = currency.value.asString else { continue }
            rows.append(CurrencyRow(code: currency.key, fullName: value))
        }
        self.section = CurrencySection(rows: rows)
    }
}

//MARK: CurrencySearchInteractorOutputProtocol Extension
extension CurrencySearchPresenter: CurrencySearchInteractorOutputProtocol {
    func didFetchCurrencies(with data: AvailableCurrencies) {
        let currenciesDTO = AvailableCurrenciesDTO(currencies: Array(data.currencies))
        generateRows(with: currenciesDTO)
        view?.dataDidLoad()
    }
    
    func didFetchCurrenciesFailed(with error: AFError) {
        view?.dataDidFail(with: error)
    }
}
