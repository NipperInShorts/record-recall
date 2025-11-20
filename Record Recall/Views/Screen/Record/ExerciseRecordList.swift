//
//  RecordDetail.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/22/22.
//

import SwiftUI
import CoreData
import Combine

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}

struct ExerciseRecordList: View {
    @ObservedObject var viewModel: AddRecordViewModel = AddRecordViewModel()
    @ObservedObject var historyModel: HistoryViewModel = HistoryViewModel()
    @State var sortedRep = ""
    @State var sortedReps: [Double] = []
    @FetchRequest var fetchRequest: FetchedResults<Record>
    @ObservedObject var exercise: Exercise
    @Environment(\.dismiss) var dismiss
    @AppStorage("userUnit") private var userUnit = Unit.imperial.rawValue



    var body: some View {
        List {
            Section {
                ForEach(sortedRecords, id:\.self) { record in
                    NavigationLink(destination: {
                        RecordLineDetail(record: record)
                    }, label: {
                        VStack(alignment: .leading) {
                            if record.date != nil {
                                HStack {
                                    HStack {
                                        if convertedWeight(for: record, to: displayUnit) > 0 {
                                            HStack(spacing: 2) {
                                                Text(Metric(value: convertedWeight(for: record, to: displayUnit)).formattedValue)
                                                    .font(.system(size: 24, weight: .semibold))
                                                    .foregroundColor(.primaryBlue)
                                                Text(displayUnit == .metric ? "kg" : "lb")
                                                    .font(.system(size: 12, weight: .medium))
                                                    .foregroundColor(.secondaryBlue)
                                            }
                                            
                                        }
                                        if convertedWeight(for: record, to: displayUnit) > 0 {
                                            Text("x")
                                                .font(.system(size: 12, weight: .semibold))
                                                .foregroundColor(.primaryBlue)
                                        }
                                        HStack(spacing: 2) {
                                            Text("\(record.reps, specifier: "%.0f")")
                                                .font(.system(size: 24, weight: .semibold))
                                                .foregroundColor(.primaryBlue)
                                            
                                            Text("rep(s)")
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundColor(.secondaryBlue)
                                        }
                                    }
                                    Spacer()
                                    Text(Helper.getFriendlyDateString(from: record.date!))
                                        .font(.footnote)
                                        .fontWeight(.medium)
                                        .foregroundColor(.secondaryBlue)
                                }
                                .padding(.top, 8)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Notes")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .italic()
                                    .foregroundColor(.primaryBlue)
                                Text((record.notes ?? "").isEmpty ? "No notes added" : record.notes!)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(.primaryBlue)
                            }
                            .padding(.vertical, 8)
                            
                        }
                    })
                    .onReceive(NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave, object: viewModel.storageProvider.persistentContainer.viewContext)) { output in
                        viewModel.storageProvider.dismissIfDeleted(output, object: exercise) {
                            dismiss()
                        } onFailure: {
                            // do nothing
                        }
                        if (fetchRequest.isEmpty) {
                            exercise.watchlist.toggle()
                            dismiss()
                        }
                    }
                }
                .onDelete(perform: delete)
            } header: {
                HStack(alignment: .center) {
                    Text("")
                        .font(.headline)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                    Spacer()
                    Menu {
                        ForEach(sortedReps, id:\.self) { theRep in
                            Button {
                                fetchRequest.nsPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
                                    NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Record.exercise.name), self.exercise.name ?? ""),
                                    NSPredicate(format: "reps = %@", Metric(value: theRep).formattedValue)
                                ])
                                sortedRep = Metric(value: theRep).formattedValue
                            } label: {
                                Text("\(Metric(value: theRep).formattedValue) rep(s)")
                                    .textCase(.none)
                            }
                        }
                        Button(role: .destructive) {
                            fetchRequest.nsPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
                                NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Record.exercise.name), self.exercise.name ?? "")
                            ])
                            sortedRep = ""
                        } label: {
                            Text("Clear Filter")
                                .foregroundColor(.red)
                        }
                        
                        
                    } label: {
                        HStack(spacing: 5) {
                            Spacer()
                            Text("Filtered by:")
                            Text(sortedRep.isEmpty ? "--" : "\(sortedRep) reps")
                                .bold()
                                .animation(.interactiveSpring(response: 0.45, dampingFraction: 0.45, blendDuration: 0.25))
                        }
                        .font(.caption)
                        .foregroundColor(.darkBlue)
                    }
                }
            }
        }
        .toolbar {
            Button {
                exercise.watchlist.toggle()
                viewModel.addToWatchlist()
            } label: {
                Image(systemName: exercise.watchlist ? "bookmark.fill" : "bookmark")
            }
        }
        .navigationTitle(exercise.name ?? "")
        .onAppear {
            fetchInitial()
            filterReps()
        }
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let removedRecord = fetchRequest[index]
            historyModel.deleteRecord(removedRecord)
        }
    }
    
    func fetchInitial() {
        
        fetchRequest.nsPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Record.exercise.name), self.exercise.name ?? "")
        ])
    }
    
    func filterReps() {
        var array: [Double] = []
        for record in fetchRequest {
            array.append(record.reps)
        }
        sortedReps = array.unique().sorted()
    }
    
    
    init(exercise: Exercise) {
        self.exercise = exercise
        _fetchRequest = FetchRequest<Record>(sortDescriptors: [
            NSSortDescriptor(keyPath: \Record.weight, ascending: false),
        ], predicate: NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Record.exercise.name), exercise.name ?? ""))
    }
    
    private var displayUnit: Unit {
        Unit(rawValue: userUnit) ?? .imperial
    }

    private func convertedWeight(for record: Record, to target: Unit) -> Double {
        let rawUnit = Unit(rawValue: record.unit ?? Unit.metric.rawValue) ?? .metric
        let kg = record.weight.toKilograms(from: rawUnit)
        return kg.fromKilograms(to: target)
    }

    private var sortedRecords: [Record] {
        fetchRequest.sorted { lhs, rhs in
            let lhsUnit: Unit = Unit(rawValue: lhs.unit ?? Unit.metric.rawValue) ?? .metric
            let rhsUnit: Unit = Unit(rawValue: rhs.unit ?? Unit.metric.rawValue) ?? .metric

            let lhsKg = lhs.weight.toKilograms(from: lhsUnit)
            let rhsKg = rhs.weight.toKilograms(from: rhsUnit)

            return lhsKg > rhsKg
        }
    }
}

