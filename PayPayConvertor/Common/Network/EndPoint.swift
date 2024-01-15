//
//  EndPoint.swift
//  PayPayConvertor
//
//  Created by Yuvaraj Selvam on 06/01/24.
//

import Foundation
import Alamofire

struct Keys {
    static let api = (Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? "Default_API_KEY")
}

/**
 Endpoint

 A protocol defining the structure and configuration for an API endpoint.
 */
protocol Endpoint {
    var apiVersion: String { get }
    var baseURL: String { get }
    var path: String { get }
    var fullURL: String { get }
    var method: HTTPMethod { get }
    var body: Parameters { get }
    var headers: HTTPHeaders { get }
    var encoding: ParameterEncoding { get }
}

extension Endpoint {
    var apiVersion: String {
        return ""
    }
    
    var baseURL: String {
        return "https://openexchangerates.org/api"
    }
    
    var fullURL: String {
        return baseURL + path + "?app_id=\(Keys.api)"
    }
    
    var body: Parameters {
        return Parameters()
    }
    
    var headers: HTTPHeaders {
        return []
    }
    
    var encoding: ParameterEncoding {
        switch method {
        case .post, .put:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
}
