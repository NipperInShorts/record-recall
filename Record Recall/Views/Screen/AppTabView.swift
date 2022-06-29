//
//  AppTAbView.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/22/22.
//

import SwiftUI

struct AppTabView: View {
    @StateObject var viewRouter = ViewRouterModel()
    
    var body: some View {
        TabView(selection: $viewRouter.selectedTab) {
            HomeScreenView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(TabOptions.home)
            
            AddRecordView()
                .tabItem {
                    Label("Add Record", systemImage: "plus")
                }
                .tag(TabOptions.addRecord)
            
            FullHistoryView()
                .tabItem {
                    Label("History", systemImage: "doc.plaintext")
                }
                .tag(TabOptions.history)
        }
        .environmentObject(viewRouter)
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
