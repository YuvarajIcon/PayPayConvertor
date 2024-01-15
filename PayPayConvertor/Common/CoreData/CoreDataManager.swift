//
//  CoreDataManager.swift
//  PayPayConvertor
//
//  Created by Yuvaraj Selvam on 13/01/24.
//

import Foundation
import CoreData

/// Protocol for entities that need to track the last synchronization date.
protocol Syncable: NSManagedObject {
    var lastSyncedDate: Date { get set }
}

/**
 CoreDataManager

 A manager responsible for handling Core Data operations.
 */
final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {
        self.registerTransformers()
    }
    
    /// The persistent container for the application.
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PayPay")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    /// The managed object context associated with the main queue.
    lazy var context: NSManagedObjectContext = {
        container.viewContext
    }()
    
    /// Registers custom transformers used in Core Data.
    func registerTransformers() {
        SecureTransformer<DynamicKeyMap>.register()
    }
    
    /// Saves changes in the managed object context.
    func save() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
