//
//  AppTabView.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/22/22.
//

import SwiftUI

struct AppTabContent: View {
    var body: some View {
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
        if #available(iOS 16, *) {
            //            NewHistoryView()
            //                .tabItem {
            //                    Label("History", systemImage: "doc.plaintext")
            //                }
            //                .tag(TabOptions.history)
        } else {
            OldHistoryView()
                .tabItem {
                    Label("History", systemImage: "doc.plaintext")
                }
                .tag(TabOptions.history)
        }
    }
}

struct OldAppTabView<Content>: View where Content: View {
    @EnvironmentObject var oldTabModel: OldViewRouterModel
    
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping ()-> Content) {
        self.content = content
    }
    
    var body: some View {
        TabView(selection: $oldTabModel.selectedTab) {
            content()
        }
    }
}

//@available(iOS 16.0, *)
//struct NewAppTabView<Content>: View where Content: View {
//    @EnvironmentObject var newTabModel: NewViewRouterModel
//    
//    let content: () -> Content
//    
//    init(@ViewBuilder content: @escaping ()-> Content) {
//        self.content = content
//    }
//    
//    var body: some View {
//        TabView(selection: $newTabModel.selectedTab) {
//            content()
//        }
//    }
//}

struct TabBuilder<Content>: View where Content: View {
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping ()-> Content) {
        self.content = content
    }
    
    var body: some View {
        content()
            .injectEnvironmentObject()
            .onAppear {
                let appearance = UITabBarAppearance()
                appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
                
                UITabBar.appearance().standardAppearance = appearance
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
    }
}

struct AppTabView: View {
    var body: some View {
        TabBuilder {
            if #available(iOS 16, *) {
                //                NewAppTabView {
                //                    AppTabContent()
                //                }
            } else {
                OldAppTabView {
                    AppTabContent()
                }
            }
        }
    }
}


struct OldModelModifier: ViewModifier {
    @StateObject var oldTabModel = OldViewRouterModel()
    func body(content: Content) -> some View {
        content
            .environmentObject(oldTabModel)
    }
}

//@available(iOS 16.0, *)
//struct NewModelModifier: ViewModifier {
//    @StateObject var newTabModel = NewViewRouterModel()
//    func body(content: Content) -> some View {
//        content
//            .environmentObject(newTabModel)
//    }
//}

extension View {
    func injectEnvironmentObject() -> some View {
        //        if #available(iOS 16, *) {
        //            return modifier(NewModelModifier())
        //        }
        //        else {
        return modifier(OldModelModifier())
    }
}



struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
