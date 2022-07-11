//
//  ExerciseRecordCellView.swift
//  Record Recall
//
//  Created by Justin Nipper on 7/8/22.
//

import SwiftUI

struct ExerciseRecordCellView: View {
    @ObservedObject var exercise: Exercise
    
    func filteredRecord(exercise: Exercise) -> Record? {
        let sortedArray = Array(exercise.records as! Set<Record>).sorted {
            $0.date!.timeIntervalSince1970 > $1.date!.timeIntervalSince1970
        }
        return sortedArray.first
    }
    
    var exerciseRecord: Record? {
        return self.filteredRecord(exercise: self.exercise)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text(exercise.name!)
                    .font(.title2)
                    .fontWeight(.medium).foregroundColor(.primaryBlue)
                Spacer()
                if exerciseRecord?.date != nil {
                    Text(Helper.getFriendlyDateString(from: exerciseRecord!.date!))
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundColor(.secondaryBlue)
                }
            }
            HStack(alignment: .top, spacing: 24) {
                if exerciseRecord != nil {
                    WeightRepsView(record: exerciseRecord!)
                    NotesView(record: exerciseRecord!)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 60)
            if exerciseRecord != nil {
                ExerciseFooter(exercise: exercise)
            }
        }
        .padding(.top, 8)
    }
}
