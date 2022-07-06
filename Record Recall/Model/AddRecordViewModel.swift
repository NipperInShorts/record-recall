//
//  AddRecordDataModel.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/20/22.
//

import Foundation
import Combine
import CoreData

enum AddExerciseStatus {
    case idle, error, running, success
}

enum AddExerciseError: Error {
    case repsIsEmpty
    case weightIsEmpty
    case exerciseNotSelected
    case failedToSave
}

// Exercise Selected
class AddRecordViewModel: ObservableObject {
    let storageProvider: StorageProvider = StorageProvider.shared
    @Published var weight = ""
    @Published var notes = ""
    @Published var unit = Unit.metric
    @Published private(set) var exercise: Exercise?
    @Published var reps: String = ""
    @Published var exerciseName: String = ""
    @Published private(set) var addExerciseStatus: AddExerciseStatus = .idle
    @Published var addError: AddExerciseError?
    @Published var date: Date = Date()
    
    func setExercise(exercise: Exercise?) -> Void {
        if let exercise = exercise {
            self.exercise = exercise
        } else {
            self.exercise = nil
        }
    }
    
    func addToWatchlist() -> Void {
        do {
            try storageProvider.persistentContainer.viewContext.save()
        } catch {
            storageProvider.persistentContainer.viewContext.rollback()
        }
    }
    
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
    
    func saveRecord() {
        let record = Record(context: storageProvider.persistentContainer.viewContext)
        record.weight = Double(self.weight) ?? 0
        record.reps = Double(self.reps) ?? 0
        record.notes = self.notes
        record.unit = self.unit.rawValue
        record.date = self.date
        self.exercise?.addToRecords(record)
        do {
            try storageProvider.persistentContainer.viewContext.save()
            resetInputs()
        } catch {
            storageProvider.persistentContainer.viewContext.rollback()
        }
    }
    
    
    func saveData() throws {      
        if self.reps.isEmpty {
            self.addError = .repsIsEmpty
            throw AddExerciseError.repsIsEmpty
        }
        
        if self.exercise == nil {
            self.addError = .exerciseNotSelected
            throw AddExerciseError.exerciseNotSelected
        }
        
        saveRecord()
    }
    
    func updateData(record: Record) throws {
        if self.reps.isEmpty {
            self.addError = .repsIsEmpty
            throw AddExerciseError.repsIsEmpty
        }
        
        if self.exercise == nil {
            self.addError = .exerciseNotSelected
            throw AddExerciseError.exerciseNotSelected
        }
        
        updateRecord(record: record)
    }
    
    private func updateRecord(record: Record) {
        record.weight = Double(self.weight) ?? 0
        record.reps = Double(self.reps) ?? 0
        record.notes = self.notes
        record.unit = self.unit.rawValue
        record.date = self.date
        do {
            try storageProvider.persistentContainer.viewContext.save()
        } catch {
            storageProvider.persistentContainer.viewContext.rollback()
        }
    }
    
    private func resetInputs() {
        self.notes = ""
        self.unit = Unit.metric
        self.weight = ""
        self.reps = ""
        self.exercise = nil
    }
    
    func initializeView(with record: Record) {
        self.exercise = record.exercise
        self.notes = record.notes ?? ""
        self.weight = Metric(value: record.weight).formattedValue
        self.reps = Metric(value: record.reps).formattedValue
        self.date = record.date!
        self.unit = Unit.metric.rawValue == record.unit ? Unit.metric : Unit.imperial
    }
}
