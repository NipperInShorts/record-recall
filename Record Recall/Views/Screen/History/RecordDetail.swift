//
//  RecordDetail.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/22/22.
//

import SwiftUI
import CoreData

struct RecordDetail: View {
    var record: Record
    @FetchRequest var fetchRequest: FetchedResults<Record>
    
    var body: some View {
        List(fetchRequest, id:\.self) { record in
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
                                
                                Text("reps")
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
                if !record.notes!.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Notes")
                            .font(.caption)
                            .fontWeight(.medium)
                            .italic()
                            .foregroundColor(.primaryBlue)
                        Text(record.notes ?? "")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.primaryBlue)
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .navigationTitle((record.exercise?.name)!)
    }
    
    init(record: Record) {
        self.record = record
        _fetchRequest = FetchRequest<Record>(sortDescriptors: [], predicate: NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Record.exercise.name), (self.record.exercise?.name!)!))
    }
}
