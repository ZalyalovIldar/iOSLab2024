//
//  CoreDataManager.swift
//  Homework 3-4
//
//  Created by Дмитрий Леонтьев on 15.01.2025.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func newBackgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Homework_3_4")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func clearOldFilms() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Film.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        try persistentContainer.viewContext.execute(deleteRequest)
        try persistentContainer.viewContext.save()
    }
    
    func clearNonFavoriteFilms() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Film.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isFavourite == false")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs
        
        let result = try persistentContainer.viewContext.execute(deleteRequest) as? NSBatchDeleteResult
        if let objectIDs = result?.result as? [NSManagedObjectID] {
            let changes = [NSDeletedObjectsKey: objectIDs]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [persistentContainer.viewContext])
        }
        try persistentContainer.viewContext.save()

    }
    
    func decodeInBackgroundContext<T>(_ type: T.Type, from data: Data) throws -> NSManagedObjectID
        where T: NSManagedObject & Decodable
    {
        let backgroundContext = CoreDataManager.shared.newBackgroundContext()
        
        let decoder = JSONDecoder()
        decoder.userInfo[.context] = backgroundContext
        
        let decodedObject = try decoder.decode(type, from: data)
        
        if backgroundContext.hasChanges {
            try backgroundContext.save()
        }
        return decodedObject.objectID
    }

    func decodeInBackgroundContextArray<T>(_ type: [T].Type, from data: Data) throws -> [NSManagedObjectID]
        where T: NSManagedObject & Decodable
    {
        let backgroundContext = CoreDataManager.shared.newBackgroundContext()
        
        let decoder = JSONDecoder()
        decoder.userInfo[.context] = backgroundContext
        
        let decodedObjects = try decoder.decode(type, from: data)
        
        if backgroundContext.hasChanges {
            try backgroundContext.save()
        }
        
        return decodedObjects.map { $0.objectID }
    }
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")!
}
