//
//  RecordDetail.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/22/22.
//

import SwiftUI

struct RecordDetail: View {
    var record: Record
    var body: some View {
        VStack {
            Text((record.exercise?.name)!)
            if record.date != nil { Text(Helper.getFriendlyDateString(from: record.date!))
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundColor(.secondaryBlue)
            }
            WeightRepsView(record: record)
            NotesView(record: record)
            Spacer()
        }
    }
}
