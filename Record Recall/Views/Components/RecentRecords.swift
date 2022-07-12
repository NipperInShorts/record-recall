//
//  RecentRecords.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/13/22.
//

import SwiftUI
import CoreData

struct RecentRecords: View {
    @FetchRequest var records: FetchedResults<Record>
    
    init() {
        let request: NSFetchRequest<Record> = Record.fetchRequest()
        request.fetchLimit = 5
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Record.date!, ascending: false),
            NSSortDescriptor(keyPath: \Record.weight, ascending: false)
        ]
        request.predicate = NSPredicate(format: "%K != nil", #keyPath(Record.exercise.name))
        _records = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Latest Records")
                .foregroundColor(.darkBlue)
                .font(
                    .system(size: 20, weight: .semibold))
                .padding(.leading)
            if (records.isEmpty) {
                
                Text("Your most recent records will appear here once added.")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primaryBlue)
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    .padding()
                    .shadow(color: .primaryBlue.opacity(0.2), radius: 5, x: 5, y: 5)
                    .shadow(color: .primaryBlue.opacity(0.2), radius: 5, x: -5, y: -5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(records) { record in
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("\(record.exercise?.name ?? "")")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.primaryBlue)
                                    Spacer()
                                    if record.date != nil {
                                        Text(Helper.getFriendlyDateString(from: record.date!))
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(.secondaryBlue)
                                    }
                                }
                                HStack(alignment: .center, spacing: 20) {
                                    Spacer()
                                    VStack(alignment: .center) {
                                        Text("Weight")
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(.secondaryBlue)
                                            .textCase(.uppercase)
                                        HStack(spacing: 2) {
                                            Text(Metric(value: record.weight).formattedValue)
                                                .font(.system(size: 24, weight: .semibold))
                                                .foregroundColor(.primaryBlue)
                                            Text(record.unit! == Unit.imperial.rawValue ? "lb" : "kg")
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundColor(.secondaryBlue)
                                        }
                                    }
                                    
                                    VStack(alignment: .center) {
                                        Text("Reps")
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(.secondaryBlue)
                                            .textCase(.uppercase)
                                        
                                        
                                        Text("\(record.reps, specifier: "%.0f")")
                                            .font(.system(size: 24, weight: .semibold))
                                            .foregroundColor(.primaryBlue)
                                    }
                                    Spacer()
                                }
                            }
                            .padding()
                            .frame(minWidth: 220, maxWidth: 264)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                            .padding(8)
                            .shadow(color: .primaryBlue.opacity(0.08), radius: 3, x: 2, y: 2)
                            .shadow(color: .primaryBlue.opacity(0.08), radius: 3, x: -2, y: -2)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct RecentRecords_Previews: PreviewProvider {
    static var previews: some View {
        RecentRecords()
    }
}
