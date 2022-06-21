//
//  StorageProvider.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/20/22.
//

import Foundation
import CoreData

public class PersistentContainer: NSPersistentContainer {}

struct StorageProvider {
    public let persistentContainer: PersistentContainer
    
    public init() {
        persistentContainer = PersistentContainer(name: "DataModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core data failed to load \(error)")
            }
        }
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
}


extension StorageProvider {
    func saveExercise(named name: String) {
        let exercise = Exercise(context: persistentContainer.viewContext)
        exercise.name = name
        
        do {
            try persistentContainer.viewContext.save()
            print("Exercise saved")
        } catch {
            persistentContainer.viewContext.rollback()
            print("Exercise save failed")
        }
    }
}

public extension Exercise {
    static var allExercises: NSFetchRequest<Exercise> {
        let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Exercise.name, ascending: true)
        ]
        return request
    }
}
