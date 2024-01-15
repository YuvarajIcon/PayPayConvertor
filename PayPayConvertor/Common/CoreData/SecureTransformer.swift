//
//  SecureTransformer.swift
//  PayPayConvertor
//
//  Created by Yuvaraj Selvam on 13/01/24.
//

import Foundation

public protocol SecureTransforming: NSSecureCoding {
    static var transformerName: NSValueTransformerName { get }
}
/**
 CoreDataManager

 A value transformer that supports secure encoding and decoding for a specified type.
 */
public class SecureTransformer<T: NSSecureCoding & NSObject & SecureTransforming>: ValueTransformer {
    public override class func transformedValueClass() -> AnyClass { T.self }
    public override class func allowsReverseTransformation() -> Bool { true }

    public override func transformedValue(_ value: Any?) -> Any? {
        guard let value = value as? T else {
            guard let value = value as? [T] else {
                return nil
            }
            return try? NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: true)
        }
        return try? NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: true)
    }

    public override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        let singleResult = try? NSKeyedUnarchiver.unarchivedObject(
            ofClass: T.self,
            from: data as Data
        )
        guard let singleResult else {
            let arrayResult = try? NSKeyedUnarchiver.unarchivedObject(
                ofClasses: [NSArray.self, NSString.self, NSData.self, T.self],
                from: data as Data
            )
            guard let arrayResult else { return nil }
            return arrayResult
        }
        return singleResult
    }

    public static func register() {
        let transformer = SecureTransformer<T>()
        ValueTransformer.setValueTransformer(transformer, forName: T.transformerName)
    }
}
