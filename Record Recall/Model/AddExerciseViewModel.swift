//
//  AddExerciseViewModel.swift
//  Record Recall
//
//  Created by Justin Nipper on 7/10/22.
//

import Foundation

class AddExerciseViewModel: ObservableObject {
    let storageProvider: StorageProvider = StorageProvider.shared
    @Published var exerciseName: String = ""
    @Published private(set) var addExerciseStatus: AddExerciseStatus = .idle
    @Published var addError: AddExerciseError?
    
    func startAddMachineOver() -> Void {
        addExerciseStatus = .idle
    }
    
    func addExercise() -> Void {
        if self.exerciseName.isEmpty {
            addExerciseStatus = .error
            return
        }
        // Save exercise
        storageProvider.saveExercise(named: self.exerciseName)
        exerciseName = ""
        addExerciseStatus = .success
    }
    
    func deleteExercise(_ exercise: Exercise) {
        do {
            storageProvider.persistentContainer.viewContext.delete(exercise)
            try storageProvider.persistentContainer.viewContext.save()
        } catch {
            print("unable to save", error.localizedDescription)
        }
    }
}
