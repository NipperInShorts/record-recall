//
//  DataHelpers.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/13/22.
//

import Foundation

struct LiftRecord: Identifiable {
    let id = UUID()
    let date: Date
    let exercise: String
    let records: [Record]
}

struct Record: Hashable, Identifiable {
    let id = UUID()
    let weight: String
    let reps: Int
}

let liftRecords = [
    LiftRecord(
        date: Date(), exercise: "Back Squat", records: [
            Record(weight: "135", reps: 1),
            Record(weight: "130", reps: 3),
            Record(weight: "120", reps: 5),
            Record(weight: "120", reps: 5),
        ]
    ),
    LiftRecord(
        date: Date(), exercise: "Front Squat", records: [
            Record(weight: "99", reps: 1),
            Record(weight: "85", reps: 3),
            Record(weight: "80", reps: 5),
            Record(weight: "80", reps: 5),
        ]
    ),
    LiftRecord(
        date: Date(), exercise: "Deadlift", records: [
            Record(weight: "140", reps: 1),
            Record(weight: "120", reps: 3),
            Record(weight: "99", reps: 5),
            Record(weight: "90", reps: 5),
        ]
    ),
]
