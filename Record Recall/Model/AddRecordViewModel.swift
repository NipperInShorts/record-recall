//
//  AddRecordDataModel.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/20/22.
//

import Foundation
import Combine

enum AddExerciseStatus {
    case idle, error, running, success
}

// Exercise Selected
class AddRecordViewModel: ObservableObject {
    
    @Published var weight = ""
    @Published var notes = ""
    @Published var unit = Unit.metric
    @Published private(set) var exercise: Exercise?
    @Published var reps: String = ""
    @Published var exerciseName: String = ""
    @Published private(set) var addExerciseStatus: AddExerciseStatus = .idle
    
    func setExercise(exercise: Exercise?) -> Void {
        if let exercise = exercise {
            self.exercise = exercise
        } else {
            self.exercise = nil
        }
    }
    
    func startAddMachineOver() -> Void {
        addExerciseStatus = .idle
    }
    
    func addExercise(named name: String) -> Void {
        if name.isEmpty {
            addExerciseStatus = .error
            return
        }
        // Save exercise
        //  StorageProvider().saveExercise(named: text)
    }

    
    func saveData() {
        print("REPS", self.reps)
        print("weight", self.weight)
        print("notes", self.notes)
        print("unit", self.unit)
    }
}
