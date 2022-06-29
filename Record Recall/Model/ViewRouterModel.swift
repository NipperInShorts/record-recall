//
//  ViewRouterModel.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/29/22.
//

import SwiftUI

enum TabOptions {
    case home, addRecord, history
}

class ViewRouterModel: ObservableObject {
    @Published var selectedTab: TabOptions = .home
    @Published var selectedDetail: String? = ""
}
