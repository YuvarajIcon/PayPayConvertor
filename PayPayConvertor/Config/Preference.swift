//
//  Preference.swift
//  PayPayConvertor
//
//  Created by Yuvaraj Selvam on 13/01/24.
//

import Foundation

@propertyWrapper
public struct UserDefault<Value> {
    public let key: String
    public let defaultValue: Value?
    
    init(key: String, defaultValue: Value? = nil) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: Value? {
        get {
            return UserDefaults.standard.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: key)
            } else {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }
}

enum TemparatureUnit: String, Codable {
    case fahrenheit = "Fahrenheit"
    case celsius = "Celsius"
}

enum PreferenceKeys: String {
    case currency
}

/**
 Preference

 A singleton class responsible for managing user preferences using UserDefaults.
 */
final class Preference {
    static let shared = Preference()
    private init() {}
    
    @UserDefault(key: PreferenceKeys.currency.rawValue, defaultValue: "USD")
    var currency: String?
}
