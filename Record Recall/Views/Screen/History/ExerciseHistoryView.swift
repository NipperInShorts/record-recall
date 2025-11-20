//
//  ExerciseHistoryView.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/22/22.
//

import SwiftUI

struct ExerciseHistoryView: View {
    @EnvironmentObject private var tabModel: OldViewRouterModel
    @FetchRequest(fetchRequest: Exercise.allExercises)
    var exercises: FetchedResults<Exercise>
    
    var body: some View {
        VStack {
            if exercises.isEmpty {
                EmptyScreenMessage(title: "You made it!", message: "There is no history of records...yet.\nYou can add records by using the plus button at the bottom.")
            } else {
                List {
                    ForEach(exercises) { exercise in
                        if exercise.records?.count ?? 0 > 0 {
                            if #available(iOS 16, *) {
                                NavigationLink(value: exercise, label: {
                                    ExerciseRecordCellView(exercise: exercise)
                                })
                            } else  {
                                NavigationLink(tag: exercise.name!, selection: $tabModel.selectedDetail) {
                                    ExerciseRecordList(exercise: exercise)
                                } label: {
                                    ExerciseRecordCellView(exercise: exercise)
                                }
                            }
                        } else {
                            VStack( alignment: .leading, spacing: 16) {
                                Text(exercise.name!)
                                    .font(.title2)
                                    .fontWeight(.medium).foregroundColor(.primaryBlue)
                                Spacer()
                                Text("No records for this exercise yet.")
                                    .font(.caption)
                                    .foregroundColor(.primaryBlue)
                                    .bold()
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .frame(maxWidth: .infinity, minHeight: 80)
                        }
                    }
                    .listRowSeparatorTint(.primaryBlue)
                    .onAppear {
                        let appearance = UITableView.appearance()
                        appearance.backgroundColor = UIColor(Color.backgroundBlue)
                        appearance.separatorColor = UIColor(Color.secondaryBlue)
                    }
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
    @ObservedObject var record: Record
    @AppStorage("userUnit") private var userUnitRaw = Unit.imperial.rawValue
    private var displayUnit: Unit { Unit(rawValue: userUnitRaw) ?? .imperial }
    
    private func convertedWeight() -> Double {
        let storedUnit = Unit(rawValue: record.unit ?? Unit.metric.rawValue) ?? .metric
        let kg = record.weight.toKilograms(from: storedUnit)
        return kg.fromKilograms(to: displayUnit)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Last Record")
                .font(.caption)
                .fontWeight(.medium)
                .italic()
                .foregroundColor(.primaryBlue)
            HStack {
                if convertedWeight() > 0 {
                    HStack(spacing: 2) {
                        Text(Metric(value: convertedWeight()).formattedValue)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primaryBlue)
                            .minimumScaleFactor(0.75)
                            .lineLimit(1)
                        Text(displayUnit == .metric ? "kg" : "lb")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondaryBlue)
                    }
                    
                }
                if convertedWeight() > 0 {
                    Text("x")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.primaryBlue)
                }
                HStack(spacing: 2) {
                    Text(String(format: "%.0f", record.reps))
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

