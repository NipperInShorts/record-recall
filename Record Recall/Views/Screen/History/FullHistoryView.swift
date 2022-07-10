//
//  FullHistoryView.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/16/22.
//

import SwiftUI

struct OldHistoryView: View {
    @EnvironmentObject private var tabModel: OldViewRouterModel
    var body: some View {
        NavigationView {
            ExerciseHistoryView()
        }
        
    }
}


@available(iOS 16, *)
struct NewHistoryView: View {
    @EnvironmentObject private var tabModel: NewViewRouterModel
    var body: some View {
        NavigationStack(path: $tabModel.presentedPath) {
            ExerciseHistoryView()
        }
    }
}
