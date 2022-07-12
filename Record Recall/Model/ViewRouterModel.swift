//
//  ViewRouterModel.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/29/22.
//

import SwiftUI

enum TabOptions {
    case home, addRecord, history, newHistory
}


class OldViewRouterModel: ObservableObject {
    @Published var selectedTab: TabOptions = .home
    @Published var selectedDetail: String? = ""
}

//@available(iOS 16.0, *)
//class NewViewRouterModel: ObservableObject {
//    @Published var selectedTab: TabOptions = .home
//    @Published var selectedDetail: String? = ""
//    @Published var presentedPath = NavigationPath()
//    
//    func addPath(path: (any Hashable)) {
//        presentedPath.append(path)
//    }
//}
