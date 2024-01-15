//
//  ConversionEndpoint.swift
//  PayPayConvertor
//
//  Created by Yuvaraj Selvam on 13/01/24.
//

import Foundation
import Alamofire

enum ConversionEndpoint: Endpoint {
    case currencies
    case latest
    
    var path: String {
        switch self {
        case .currencies:
            return "/currencies.json"
        case .latest:
            return "/latest.json"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .currencies, .latest:
            return .get
        }
    }
}
