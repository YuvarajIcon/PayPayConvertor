//
//  DynamicKeyMap.swift
//  PayPayConvertor
//
//  Created by Yuvaraj Selvam on 13/01/24.
//

import Foundation

enum TransformerName {
    static let dynamicKeyTransformer = NSValueTransformerName("DynamicKeyMapTransformer")
}

/**
 DynamicKeyMap

 A codable object to map dangling JSON.
 */
public class DynamicKeyMap: NSObject, Codable, NSCoding, NSSecureCoding, SecureTransforming {
    public static var transformerName = TransformerName.dynamicKeyTransformer
    public static var supportsSecureCoding: Bool = true
    
    public let key: String
    public let value: AnyCodable
    
    enum CodingKeys: String, CodingKey {
        case key
        case value
    }
    
/**
    Initializes a new instance of DynamicKeyMap.
 
    - Parameters:
        - key: The key in the key-value pair.
        - value: The value in the key-value pair, represented as AnyCodable.
 */
    init(key: String, value: AnyCodable) {
        self.key = key
        self.value = value
    }
    
    required public init?(coder aDecoder: NSCoder) {
        let container = aDecoder.decodeObject(forKey: CodingKeys.key.stringValue) as? String
        let valueData = aDecoder.decodeObject(forKey: CodingKeys.value.stringValue) as? Data
        
        guard let key = container,
              let valueData = valueData,
              let value = try? JSONDecoder().decode(AnyCodable.self, from: valueData) else {
            return nil
        }
        
        self.key = key
        self.value = value
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(key, forKey: CodingKeys.key.stringValue)
        let encoder = JSONEncoder()
        if let valueData = try? encoder.encode(value) {
            aCoder.encode(valueData, forKey: CodingKeys.value.stringValue)
        }
    }
}
