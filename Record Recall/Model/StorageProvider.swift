//
//  StorageProvider.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/20/22.
//

import Foundation
import CoreData

public class PersistentContainer: NSPersistentContainer {}

public class StorageProvider {
    public let persistentContainer: PersistentContainer
    static let shared = StorageProvider()
    public init() {
        persistentContainer = PersistentContainer(name: "DataModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core data failed to load \(error)")
            }
        }
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
}


extension StorageProvider {
    func saveExercise(named name: String) {
        let exercise = Exercise(context: StorageProvider.shared.persistentContainer.viewContext)
        exercise.name = name
        do {
            try StorageProvider.shared.persistentContainer.viewContext.save()
        } catch {
            StorageProvider.shared.persistentContainer.viewContext.rollback()
        }
    }
    
    func dismissIfDeleted(_ notification: Notification, object: NSManagedObject, completion: ()-> Void, onFailure: ()-> Void) {
        if let userInfo = notification.userInfo {
            if let deletedObjects = userInfo[NSManagedObjectContext.NotificationKey.deletedObjects.rawValue] as? Set<NSManagedObject> {
                if deletedObjects.contains(where: {$0.objectID == object.objectID}) {
                    completion()
                }
            }
        } else {
            onFailure()
        }
    }
}

public extension Exercise {
    static var allExercises: NSFetchRequest<Exercise> {
        let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Exercise.name, ascending: true),
        ]
        return request
    }
}

public extension Record {
    static var allRecords: NSFetchRequest<Record> {
        let request: NSFetchRequest<Record> = Record.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Record.exercise?.name, ascending: true),
            NSSortDescriptor(keyPath: \Record.weight, ascending: false),
        ]
        return request
    }
}
