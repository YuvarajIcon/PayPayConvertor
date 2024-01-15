//
//  ResponseError.swift
//  PayPayConvertor
//
//  Created by Yuvaraj Selvam on 13/01/24.
//

import Foundation

struct ErrorResponse: Codable {
    let error: Bool
    let status: Int
    let message: String
    let description: String
}
