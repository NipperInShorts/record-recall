//
//  NoExerciseHistory.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/22/22.
//

import SwiftUI

struct NoExerciseHistory: View {
    var body: some View {
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
}

struct NoExerciseHistory_Previews: PreviewProvider {
    static var previews: some View {
        NoExerciseHistory()
    }
}
