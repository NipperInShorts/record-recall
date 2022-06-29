//
//  ExerciseHistoryView.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/22/22.
//

import SwiftUI

struct ExerciseHistoryView: View {
    @EnvironmentObject private var tabModel: ViewRouterModel
    @FetchRequest(fetchRequest: Exercise.allExercises)
    var exercises: FetchedResults<Exercise>
    
    func filteredRecords(exercise: Exercise) -> [Record] {
        let sortedArray = Array(exercise.records as! Set<Record>).sorted {
            $0.date!.timeIntervalSince1970 > $1.date!.timeIntervalSince1970
        }
        
        if sortedArray.count > 0 {
            return [sortedArray[0]]
        } else {
            return sortedArray
        }
    }
    
    var body: some View {
        VStack {
            if exercises.isEmpty {
                EmptyScreenMessage(title: "You made it!", message: "There is no history of records...yet.\nYou can add records by using the plus button at the bottom.")
            } else {
                List {
                    ForEach(exercises) { exercise in
                        ForEach(filteredRecords(exercise: exercise), id: \.self) { record in
                            NavigationLink(
                                tag: exercise.name!,
                                selection: $tabModel.selectedDetail
                            ) {
                                RecordDetail(record: record)
                            } label: {
                                VStack(spacing: 16) {
                                    HStack {
                                        Text(exercise.name!)
                                            .font(.title2)
                                            .fontWeight(.medium).foregroundColor(.primaryBlue)
                                        Spacer()
                                        if record.date != nil { Text(Helper.getFriendlyDateString(from: record.date!))
                                                .font(.footnote)
                                                .fontWeight(.medium)
                                                .foregroundColor(.secondaryBlue)
                                        }
                                    }
                                    HStack(alignment: .top, spacing: 24) {
                                        WeightRepsView(record: record)
                                        NotesView(record: record)
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: 60)
                                    ExerciseFooter(exercise: exercise.name!)
                                }
                                .padding(.top, 8)
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .onAppear {
                    let appearance = UITableView.appearance()
                    appearance.backgroundColor = UIColor(Color.backgroundBlue)
                    appearance.separatorColor = UIColor(Color.secondaryBlue)
                }
            }
        }
        .background(Color.backgroundBlue)
        .navigationTitle("History")
    }
}


struct ExerciseHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseHistoryView()
    }
}

struct NotesView: View {
    var record: Record
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            if !record.notes!.isEmpty {
                Text("Notes")
                    .font(.caption)
                    .fontWeight(.medium)
                    .italic()
                    .foregroundColor(.primaryBlue)
                Text(record.notes ?? "")
                    .font(.system(size: 14, weight: .regular))
                    .frame(maxWidth:  .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .foregroundColor(.primaryBlue)
                    .minimumScaleFactor(0.85)
            } else {
                Text("Great work!\nOn to the next")
                    .font(.system(size: 14, weight: .medium))
                    .italic()
                    .foregroundColor(.primaryBlue)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct WeightRepsView: View {
    var record: Record
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Last Record")
                .font(.caption)
                .fontWeight(.medium)
                .italic()
                .foregroundColor(.primaryBlue)
            HStack {
                if (!(Metric(value: record.weight).formattedValue == "0") || record.weight > 0) {
                    HStack(spacing: 2) {
                        Text(Metric(value: record.weight).formattedValue)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primaryBlue)
                            .minimumScaleFactor(0.75)
                            .lineLimit(1)
                        Text(record.unit == Unit.metric.rawValue ? "kg" : "lb")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondaryBlue)
                    }
                    
                }
                if (!(Metric(value: record.weight).formattedValue == "0") || record.weight > 0) {
                    Text("x")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.primaryBlue)
                }
                HStack(spacing: 2) {
                    Text("\(record.reps, specifier: "%.0f")")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primaryBlue)
                        .minimumScaleFactor(0.75)
                        .lineLimit(1)
                    Text("rep(s)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondaryBlue)
                }
                .minimumScaleFactor(0.75)
                .lineLimit(1)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

