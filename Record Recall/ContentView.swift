//
//  ContentView.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/13/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack(alignment: .leading) {
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
        .preferredColorScheme(.light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}
