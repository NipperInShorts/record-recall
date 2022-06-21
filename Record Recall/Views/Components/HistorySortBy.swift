//
//  HistorySortBy.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/13/22.
//

import SwiftUI

enum SortBy {
    case weight, reps
}

struct HistorySortBy: View {
    @State private var sortBy: SortBy = .weight
    
    var body: some View {
        HStack(alignment: .center) {
            Text("History")
                .font(.title3)
                .fontWeight(.medium)
            Menu {
                Button {
                    sortBy = .reps
                } label: {
                    Text("Sort by reps")
                }
                
                Button {
                    sortBy = .weight
                } label: {
                    Text("Sort by weight")
                }

            } label: {
                HStack(spacing: 5) {
                    Spacer()
                    
                    Text("Sorted by:")
                    Text(sortBy == .reps ? "Reps" : "Weight")
                        .bold()
                        .animation(.interactiveSpring(response: 0.45, dampingFraction: 0.45, blendDuration: 0.25))
                }
                .font(.caption)
            }
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(.darkBlue)
    }
    
    func sortByReps() -> Void {
        sortBy = .reps
    }
    
    func sortByWeight() -> Void {
        sortBy = .weight
    }
}

struct HistorySortBy_Previews: PreviewProvider {
    static var previews: some View {
        HistorySortBy()
    }
}
