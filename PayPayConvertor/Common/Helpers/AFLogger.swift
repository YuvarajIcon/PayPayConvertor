//
//  AFLogger.swift
//  PayPayConvertor
//
//  Created by Yuvaraj Selvam on 06/01/24.
//

import Foundation
import Alamofire

/**
 AFLogger

 A custom event monitor for Alamofire to log request and response details.
 */
final class AFLogger: EventMonitor {
    func requestDidResume(_ request: Request) {
        let body = request.request.flatMap { $0.httpBody.map { String(decoding: $0, as: UTF8.self) } } ?? "None"
        let message = """
        ⌛️ Request Started: \(request)
        ⌛️ Body Data: \(body)
        """
        debugPrint(message)
    }
    
    func requestDidFinish(_ request: Request) {
        debugPrint(request.description)
    }
    
    func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        guard response.data != nil else {
            return
        }
        debugPrint("⚡️ Response Received:")
        debugPrint(response.debugDescription as NSString)
        debugPrint("⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️⛔️")
        debugPrint("\n" as NSString)
    }
}
