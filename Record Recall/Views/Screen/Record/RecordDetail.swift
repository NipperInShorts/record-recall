//
//  RecordDetail.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/22/22.
//

import SwiftUI
import CoreData

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}

struct RecordDetail: View {
    @ObservedObject var viewModel: AddRecordViewModel = AddRecordViewModel()
    @State var sortedRep = ""
    @State var sortedReps: [Double] = []
    @FetchRequest var fetchRequest: FetchedResults<Record>
    var record: Record
    
    var body: some View {
        List {
            Section {
                ForEach(fetchRequest, id:\.self) { record in
                    NavigationLink(destination: {
                        RecordLineDetail(record: record)
                    }, label: {
                        VStack(alignment: .leading) {
                            if record.date != nil {
                                HStack {
                                    HStack {
                                        if (!(Metric(value: record.weight).formattedValue == "0") || record.weight > 0) {
                                            HStack(spacing: 2) {
                                                Text(Metric(value: record.weight).formattedValue)
                                                    .font(.system(size: 24, weight: .semibold))
                                                    .foregroundColor(.primaryBlue)
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
                }
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
                                NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Record.exercise.name), (self.record.exercise?.name!)!),
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
                            NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Record.exercise.name), (self.record.exercise?.name!)!)
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
                record.exercise?.watchlist.toggle()
                viewModel.addToWatchlist()
            } label: {
                Image(systemName: record.exercise!.watchlist ? "bookmark.fill" : "bookmark")
            }
        }
        .navigationTitle((record.exercise?.name)!)
        .onAppear {
            fetchInitial()
            filterReps()
        }
}

func fetchInitial() {
    fetchRequest.nsPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
        NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Record.exercise.name), (self.record.exercise?.name!)!)
    ])
}

func filterReps() {
    var array: [Double] = []
    for record in fetchRequest {
        array.append(record.reps)
    }
    sortedReps = array.unique().sorted()
}


init(record: Record) {
    self.record = record
    _fetchRequest = FetchRequest<Record>(sortDescriptors: [
        NSSortDescriptor(keyPath: \Record.weight, ascending: false),
    ], predicate: NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Record.exercise.name), (self.record.exercise?.name!)!))
}
}
