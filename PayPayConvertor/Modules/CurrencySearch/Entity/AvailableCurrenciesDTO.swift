//
//  AvailableCurrencies.swift
//  PayPayConvertor
//
//  Created by Yuvaraj Selvam on 13/01/24.
//

import Foundation

struct AvailableCurrenciesDTO: Codable {
    let currencies: [DynamicKeyMap]
    
    init(currencies: [DynamicKeyMap]) {
        self.currencies = currencies
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let dict = try container.decode([String:String].self)
        var currencies: [DynamicKeyMap] = []
        for (key, value) in zip(dict.keys, dict.values) {
            currencies.append(DynamicKeyMap(key: key, value: AnyCodable(value: value)))
        }
        self.currencies = currencies
    }
}
