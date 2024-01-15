//
//  ExchangeRates.swift
//  PayPayConvertor
//
//  Created by Yuvaraj Selvam on 13/01/24.
//

import Foundation
import CoreData

@objc(ExchangeRates)
public class ExchangeRates: NSManagedObject, Syncable {
    public class var entityName: String {
        return "ExchangeRates"
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExchangeRates> {
        return NSFetchRequest<ExchangeRates>(entityName: self.entityName)
    }
    
    @NSManaged public var lastSyncedDate: Date
    @NSManaged public var disclaimer: String
    @NSManaged public var license: String
    @NSManaged public var timestamp: Int64
    @NSManaged public var base: String
    @NSManaged public var rates: [DynamicKeyMap]
    
    class func create() -> ExchangeRates {
        let context = CoreDataManager.shared.context
        let availableCurrencies = ExchangeRates(context: context)
        return availableCurrencies
    }

    class func fetch() -> ExchangeRates? {
        let request: NSFetchRequest<ExchangeRates> = ExchangeRates.fetchRequest()
        return try? CoreDataManager.shared.context.fetch(request).first
    }

    func update(with remote: ExchangeRatesDTO) {
        self.disclaimer = remote.disclaimer
        self.base = remote.base
        self.license = remote.license
        self.rates = remote.rates.rates
        self.timestamp = Int64(remote.timestamp)
        self.lastSyncedDate = Date()
        CoreDataManager.shared.save()
    }

    func delete() {
        CoreDataManager.shared.context.delete(self)
        CoreDataManager.shared.save()
    }
}
