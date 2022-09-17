//
//  CondensedHistoryView.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/13/22.
//

import SwiftUI
import CoreData

class WatchListViewModel: ObservableObject {
    @Published var watchlist: [Exercise] = []
    let storageProvider: StorageProvider = StorageProvider.shared
    let viewContext = StorageProvider.shared.persistentContainer.viewContext
    
    func getWatchlist() {
        let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Exercise.name, ascending: true),
        ]
        fetchRequest.predicate = NSPredicate(format: "watchlist == YES")
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            watchlist = result
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct CondensedHistoryView: View {
    @ObservedObject var viewModel: WatchListViewModel = WatchListViewModel()
    
    let columns = [
        GridItem(.flexible(),spacing: 0, alignment: .center),
        GridItem(.flexible(), spacing: 0, alignment: .center),
        GridItem(.flexible(), spacing: 0, alignment: .center)
    ]
    
    func filteredRecords(exercise: Exercise) -> [Record] {
        let sortedArray = Array(exercise.records as! Set<Record>).sorted {
            $0.weight > $1.weight
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
                Text("Watchlist")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.darkBlue)
                Spacer()
            }
            .padding()
            if viewModel.watchlist.count > 0 {
                LazyVGrid(columns: columns, alignment: .leading, spacing: 0) {
                    ForEach(viewModel.watchlist, id:\.self) { exercise in
                        Section(header: ExerciseHeader(exercise: exercise.name!), footer: ExerciseFooter(exercise: exercise)) {
                            Group {
                                ExerciseGroupHeader(headerTitle:"weight")
                                ExerciseGroupHeader(headerTitle:"reps")
                                ExerciseGroupHeader(headerTitle:"date")
                            }
                            
                            ForEach(Array(filteredRecords(exercise: exercise).enumerated()), id: \.element) { index, individualRecord in
                                RecordLineItem(record: individualRecord, date: individualRecord.date!, index: index)
                            }
                        }
                        .onReceive(NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave, object: viewModel.viewContext)) { output in
                            viewModel.getWatchlist()
                            viewModel.storageProvider.dismissIfDeleted(output, object: exercise) {
                                viewModel.getWatchlist()
                            } onFailure: {
                                // do nothing
                            }
                        }
                    }
                }
            } else {
                EmptyScreenMessage(title: "Nothing on your Watchlist",
                                   message: "Hit the Bookmark icon on the exercise detail screen to add to your Watchlist"
                )
                .padding(.top, 30)
            }
        }
        .onAppear {
            viewModel.getWatchlist()
        }
    }
}

struct ExerciseFooter: View {
    var exercise: Exercise
    var body: some View {
        if #available(iOS 16, *) {
            NewExerciseFooter(exercise: exercise)
        } else {
            OldExerciseFooter(exercise: exercise)
        }
    }
}

struct OldExerciseFooter: View {
    @EnvironmentObject private var tabModel: OldViewRouterModel
    let exercise: Exercise
    
    var body: some View {
        Button {
            tabModel.selectedTab = .history
            tabModel.selectedDetail = exercise.name!
        } label: {
            Group {
                Text("View more ")
                    .font(.caption)
                    .foregroundColor(.primaryBlue)
                +
                Text(exercise.name!)
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

@available(iOS 16, *)
struct NewExerciseFooter: View {
    @EnvironmentObject private var tabModel: NewViewRouterModel
    let exercise: Exercise

    var body: some View {
        Button {
            tabModel.selectedTab = .history
            if !tabModel.presentedPath.isEmpty {
                tabModel.presentedPath.removeLast()
            }
            tabModel.addPath(path: exercise)
        } label: {
            Group {
                Text("View more ")
                    .font(.caption)
                    .foregroundColor(.primaryBlue)
                +
                Text(exercise.name ?? "")
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
    @ObservedObject var record: Record
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
            Text("\(Helper.getFriendlyDateStringWithYear(from: date))")
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
