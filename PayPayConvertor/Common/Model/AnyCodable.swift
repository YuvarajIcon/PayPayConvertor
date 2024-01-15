//
//  AnyCodable.swift
//  PayPayConvertor
//
//  Created by Yuvaraj Selvam on 13/01/24.
//

import Foundation

/**
 AnyCodable

 A type-erased wrapper for values that conform to Codable and NSCoding protocols.
*/
public class AnyCodable: Codable, NSCoding {
    /// The wrapped value.
    public var value: Any
    
    /// Retrieves the wrapped value as a String, if possible.
    public var asString: String? {
        value as? String
    }
    
    /// Retrieves the wrapped value as an Int, if possible.
    public var asInt: Int? {
        value as? Int
    }
    
    /// Retrieves the wrapped value as a Double, if possible.
    public var asDouble: Double? {
        value as? Double
    }
    
    /// Initializes an instance of AnyCodable with a given value.
    /// - Parameter value: The value to be wrapped.
    public init(value: Any) {
        self.value = value
    }
    
    required public init?(coder aDecoder: NSCoder) {
        guard let value = aDecoder.decodeObject() else {
            return nil
        }
        self.value = value
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(value, forKey: "value")
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intVal = try? container.decode(Int.self) {
            value = intVal
        } else if let doubleVal = try? container.decode(Double.self) {
            value = doubleVal
        } else if let stringVal = try? container.decode(String.self) {
            value = stringVal
        } else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "the container contains nothing serializable"
            )
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let intVal = value as? Int {
            try container.encode(intVal)
        } else if let doubleVal = value as? Double {
            try container.encode(doubleVal)
        } else if let stringVal = value as? String {
            try container.encode(stringVal)
        } else {
            throw EncodingError.invalidValue(
                value, EncodingError.Context.init(
                    codingPath: [],
                    debugDescription: "The value is not encodable"
                )
            )
        }
    }
}
