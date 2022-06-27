//
//  RecordsHistoryView.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/22/22.
//

import SwiftUI

struct RecordsHistoryView: View {
    @State var isSortedAscending = true
    @FetchRequest(fetchRequest: Record.allRecords)
    var records: FetchedResults<Record>
    var body: some View {
        VStack {
            if records.isEmpty {
                VStack(spacing: 8) {
                    Text("You made it!")
                        .bold()
                    Text("There is no history of records...yet.\nYou can add records by using the plus button at the bottom.")
                }
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .rotationEffect(Angle(degrees: -15))
                .padding()
                .shadow(color: .primaryBlue.opacity(0.2), radius: 5, x: 5, y: 5)
                .shadow(color: .primaryBlue.opacity(0.2), radius: 5, x: -5, y: -5)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            else {
                List(records) { record in
                    VStack(spacing: 16) {
                        HStack {
                            Text(((record.exercise?.name)!))
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
                                        Text("reps")
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(.secondaryBlue)
                                    }
                                    .minimumScaleFactor(0.75)
                                    .lineLimit(1)
                                    
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
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
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        
                    }
                }
                .onAppear {
                    let appearance = UITableView.appearance()
                    appearance.backgroundColor = UIColor(Color.backgroundBlue)
                }
            }
        }
        .background(Color.backgroundBlue)
        .navigationTitle("History")
        .toolbar {
            Button(action: {
                isSortedAscending.toggle()
            }, label: {
                Image(systemName: isSortedAscending ? "arrow.down" : "arrow.up")
            })
            .disabled(records.isEmpty)
        }
        .onChange(of: isSortedAscending) { ascending in
            records.sortDescriptors = [
                SortDescriptor(\Record.exercise?.name, order: ascending ? .forward : .reverse)
            ]
        }
    }
}
struct RecordsHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        RecordsHistoryView()
    }
}
