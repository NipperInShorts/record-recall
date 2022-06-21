//
//  AddRecordDataModel.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/20/22.
//

import Foundation
import Combine

// Exercise Selected
class AddRecordViewModel: ObservableObject {
    
    @Published var weight = ""
    @Published var notes = ""
    @Published var unit = Unit.metric
    @Published private(set) var exercise: Exercise?
    @Published var reps: String = ""

    
    func setExercise(exercise: Exercise?) -> Void {
        if let exercise = exercise {
            self.exercise = exercise
        } else {
            self.exercise = nil
        }
    }

    
    func saveData() {
        print("REPS", self.reps)
        print("weight", self.weight)
        print("notes", self.notes)
        print("unit", self.unit)
    }
}

//                                            .onReceive(Just(weight), perform: { newValue in
//                                                weight = Helper.weightValidator(newValue: newValue, weight: weight)
//                                            })
