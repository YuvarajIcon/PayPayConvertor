//
//  AvailableCurrencies.swift
//  PayPayConvertor
//
//  Created by Yuvaraj Selvam on 13/01/24.
//

import Foundation
import CoreData

@objc(AvailableCurrencies)
public class AvailableCurrencies: NSManagedObject, Syncable {
    @NSManaged public var lastSyncedDate: Date
    @NSManaged public var currencies: [DynamicKeyMap]
    
    public class var entityName: String {
        return "AvailableCurrencies"
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<AvailableCurrencies> {
        return NSFetchRequest<AvailableCurrencies>(entityName: self.entityName)
    }
    
    class func create() -> AvailableCurrencies {
        let context = CoreDataManager.shared.context
        let availableCurrencies = AvailableCurrencies(context: context)
        return availableCurrencies
    }

    class func fetch() -> AvailableCurrencies? {
        let request: NSFetchRequest<AvailableCurrencies> = AvailableCurrencies.fetchRequest()
        return try? CoreDataManager.shared.context.fetch(request).first
    }

    func update(with remote: AvailableCurrenciesDTO) {
        self.currencies = remote.currencies
        self.lastSyncedDate = Date()
        CoreDataManager.shared.save()
    }

    func delete() {
        CoreDataManager.shared.context.delete(self)
        CoreDataManager.shared.save()
    }
}
