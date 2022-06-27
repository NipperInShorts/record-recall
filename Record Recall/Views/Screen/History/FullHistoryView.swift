//
//  FullHistoryView.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/16/22.
//

import SwiftUI

struct FullHistoryView: View {

    var body: some View {
        NavigationView {
            ExerciseHistoryView()
        }
    }
}

struct FullHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        FullHistoryView()
    }
}
