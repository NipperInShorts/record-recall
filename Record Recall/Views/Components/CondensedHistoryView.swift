//
//  CondensedHistoryView.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/13/22.
//

import SwiftUI

struct CondensedHistoryView: View {
    let columns = [
        GridItem(.flexible(),spacing: 0, alignment: .center),
        GridItem(.flexible(), spacing: 0, alignment: .center),
        GridItem(.flexible(), spacing: 0, alignment: .center)
    ]
    var body: some View {
        VStack {
            
            HistorySortBy()
                .padding()
            LazyVGrid(columns: columns, alignment: .leading, spacing: 0) {
//                ForEach(liftRecords) { liftRecord in
//                    Section(header: ExerciseHeader(exercise: liftRecord.exercise), footer: ExerciseFooter(exercise: liftRecord.exercise)) {
//                        Group {
//                            ExerciseGroupHeader(headerTitle:"weight")
//                            ExerciseGroupHeader(headerTitle:"reps")
//                            ExerciseGroupHeader(headerTitle:"date")
//                        }
//                        ForEach(Array(zip(liftRecord.records.indices, liftRecord.records)), id: \.1) { index, individualRecord in
//                            RecordLineItem(record: individualRecord, date: liftRecord.date, index: index)
//                        }
//                    }
//                }
            }
        }
    }
}

struct ExerciseFooter: View {
    let exercise: String
    var body: some View {
        Group {
            Text("View more ")
                .font(.caption)
                .foregroundColor(.primaryBlue)
            +
            Text(exercise)
                .font(.caption)
                .foregroundColor(.primaryBlue)
                .bold()
            +
            Text(" records")
                .font(.caption)
                .foregroundColor(.primaryBlue)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 20)
        .padding(.bottom, 30)
    }
}

//struct RecordLineItem: View {
//    let record: Record
//    let date: Date
//    let index: Int
//    var body: some View {
//        Group {
//            HStack(spacing: 2) {
//                Text(record.weight)
//                    .bold()
//                    .foregroundColor(.primaryBlue)
//                Text("kgs")
//                    .font(.caption)
//                    .fontWeight(.medium)
//                    .foregroundColor(.secondaryBlue)
//            }
//            Text("\(record.reps)")
//                .foregroundColor(.primaryBlue)
//                .bold()
//            Text("\(Helper.getFriendlyDateString(from: date))")
//                .foregroundColor(.secondaryBlue)
//                .font(.caption)
//                .fontWeight(.medium)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .frame(minHeight: 22)
//        .padding(.vertical, 8)
//        .background(isEvenRow(index) ? .clear : .highlightBlue)
//    }
//    
//    private func isEvenRow(_ index: Int) -> Bool {
//        return (index % 2) == 0
//    }
//}

struct ExerciseHeader: View {
    let exercise: String
    var body: some View {
        Text(exercise)
            .font(.headline)
            .padding(.bottom, 10)
            .padding(.leading)
            .foregroundColor(.primaryBlue)
    }
}

struct ExerciseGroupHeader: View {
    let headerTitle: String
    var body: some View {
        Text(headerTitle)
            .fontWeight(.medium)
            .font(.subheadline)
            .underline()
            .foregroundColor(.secondaryBlue)
            .padding(.bottom, 6)
    }
}


struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        CondensedHistoryView()
    }
}
