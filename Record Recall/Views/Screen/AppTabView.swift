//
//  AppTAbView.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/22/22.
//

import SwiftUI

struct AppTabView: View {
    var body: some View {
        TabView {
            HomeScreenView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            AddRecordView()
                .tabItem {
                    Label("Add Record", systemImage: "plus")
                }
            
            FullHistoryView()
                .tabItem {
                    Label("History", systemImage: "doc.plaintext")
                }
        }
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}


struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
