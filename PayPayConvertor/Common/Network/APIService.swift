//
//  APIService.swift
//  PayPayConvertor
//
//  Created by Yuvaraj Selvam on 06/01/24.
//

import Foundation
import Alamofire

/**
 APIService

 A singleton class responsible for handling API requests using Alamofire.
 */
final class APIService {
    static let shared = APIService()
    
    lazy private(set) var session: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 120
        return Session(configuration: configuration, eventMonitors: [AFLogger()])
    }()
    
    private init() { }
    
    /// Performs an API request using the provided endpoint configuration.
    /// - Parameters:
    ///   - endPoint: The endpoint configuration.
    ///   - model: The type of the expected successful response.
    ///   - errorModel: The type of the expected error response.
    ///   - success: A closure to be executed on successful API response.
    ///   - failure: A closure to be executed on API request failure.
    func request <T: Codable, U: Codable>(
        endPoint: Endpoint,
        model: T.Type,
        errorModel: U.Type,
        success: @escaping (T) -> Void,
        failure: @escaping (AFError, U?) -> Void) {
        session.request(
            endPoint.fullURL,
            method: endPoint.method,
            parameters: endPoint.body,
            encoding: endPoint.encoding,
            headers: endPoint.headers
        )
        .response { response in
            switch response.result {
            case .success(let data):
                let result: Result<T, AFError> = self.parse(data: data)
                switch result {
                case .success(let decodedObject):
                    success(decodedObject)
                case .failure(let error):
                    let result: Result<U, AFError> = self.parse(data: data)
                    switch result {
                    case .success(let decodedObject):
                        failure(error, decodedObject)
                    case .failure(let error):
                        failure(error, nil)
                    }
                }
            case .failure(let error):
                debugPrint(error.localizedDescription)
                failure(error, nil)
            }
        }
    }
    
    private func parse<T: Codable>(data: Data?) -> Result<T, AFError> {
        guard let data = data else {
            let error = makeError(userInfo: ["message": "No data received"])
            let reason: AFError.ResponseValidationFailureReason = .customValidationFailed(error: error)
            let afError: AFError = .responseValidationFailed(reason: reason)
            return .failure(afError)
        }
        do {
            let response = try JSONDecoder().decode(T.self, from: data)
            return .success(response)
        } catch let exception {
            debugPrint(exception.localizedDescription)
            let reason: AFError.ResponseSerializationFailureReason = .decodingFailed(error: exception)
            let error: AFError = .responseSerializationFailed(reason: reason)
            return .failure(error)
        }
    }
    
    private func makeError(userInfo: [String: Any]?) -> NSError {
        let domain = "com.icon.PayPayConvertor.api.error"
        return NSError(
            domain: domain,
            code: 9999,
            userInfo: userInfo
        )
    }
}
