//
//  ExchangeRates.swift
//  PayPayConvertor
//
//  Created by Yuvaraj Selvam on 13/01/24.
//

import Foundation

struct ExchangeRatesDTO: Codable {
    let disclaimer: String
    let license: String
    let timestamp: Int
    let base: String
    let rates: RatesDTO
}

struct RatesDTO: Codable {
    let rates: [DynamicKeyMap]
    
    init(rates: [DynamicKeyMap]) {
        self.rates = rates
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let dict = try container.decode([String: Double].self)
        var rates: [DynamicKeyMap] = []
        for (key, value) in dict {
            rates.append(DynamicKeyMap(key: key, value: AnyCodable(value: value)))
        }
        self.rates = rates
    }
}
