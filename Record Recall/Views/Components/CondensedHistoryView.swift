//
//  CondensedHistoryView.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/13/22.
//

import SwiftUI

struct CondensedHistoryView: View {
    @ObservedObject var viewModel: AddRecordViewModel = AddRecordViewModel()
    @FetchRequest var fetchRequest: FetchedResults<Exercise>
    
    let columns = [
        GridItem(.flexible(),spacing: 0, alignment: .center),
        GridItem(.flexible(), spacing: 0, alignment: .center),
        GridItem(.flexible(), spacing: 0, alignment: .center)
    ]
    
    func filteredRecords(exercise: Exercise) -> [Record] {
        let sortedArray = Array(exercise.records as! Set<Record>).sorted {
            $0.date!.timeIntervalSince1970 > $1.date!.timeIntervalSince1970
        }
        
        if sortedArray.count > 0 {
            let max = 4
            let upperBound = sortedArray.count >= max ? max - 1 : sortedArray.count - 1
            return Array(sortedArray.prefix(through: upperBound))
        } else {
            return sortedArray
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Watch list")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.darkBlue)
                Spacer()
            }
            .padding()
            if fetchRequest.count > 0 {
                LazyVGrid(columns: columns, alignment: .leading, spacing: 0) {
                    ForEach(fetchRequest, id:\.self) { exercise in
                        Section(header: ExerciseHeader(exercise: exercise.name!), footer: ExerciseFooter(exercise: exercise.name!)) {
                            Group {
                                ExerciseGroupHeader(headerTitle:"weight")
                                ExerciseGroupHeader(headerTitle:"reps")
                                ExerciseGroupHeader(headerTitle:"date")
                            }
                            
                            ForEach(Array(filteredRecords(exercise: exercise).enumerated()), id: \.element) { index, individualRecord in
                                RecordLineItem(record: individualRecord, date: individualRecord.date!, index: index)
                            }
                        }
                    }
                }
            } else {
                EmptyScreenMessage(title: "Nothing on your Watch list",
                                   message: "Hit the Bookmark icon on the exercise detail screen to add to your Watch list"
                )
                .padding(.top, 30)
            }
        }
    }
    
    init() {
        _fetchRequest = FetchRequest<Exercise>(sortDescriptors: [
            NSSortDescriptor(keyPath: \Exercise.name, ascending: true),
        ], predicate: NSPredicate(format: "watchlist == YES"))
    }
}

struct ExerciseFooter: View {
    @EnvironmentObject private var tabModel: ViewRouterModel
    let exercise: String
    var body: some View {
        Button {
            tabModel.selectedTab = .history
            tabModel.selectedDetail = exercise
            
        } label: {
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
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 8)
        
    }
}

struct RecordLineItem: View {
    let record: Record
    let date: Date
    let index: Int
    var body: some View {
        Group {
            HStack(spacing: 2) {
                Text(Metric(value: record.weight).formattedValue)
                    .bold()
                    .foregroundColor(.primaryBlue)
                Text(record.unit == Unit.metric.rawValue ? "kg" : "lb")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondaryBlue)
            }
            Text("\(record.reps, specifier: "%.0f")")
                .foregroundColor(.primaryBlue)
                .bold()
            Text("\(Helper.getFriendlyDateString(from: date))")
                .foregroundColor(.secondaryBlue)
                .font(.caption)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .frame(minHeight: 22)
        .padding(.vertical, 8)
        .background(isEvenRow(index) ? .clear : .highlightBlue)
    }
    
    private func isEvenRow(_ index: Int) -> Bool {
        return (index % 2) == 0
    }
}

struct ExerciseHeader: View {
    let exercise: String
    var body: some View {
        Text(exercise)
            .font(.headline)
            .padding(.vertical, 10)
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
