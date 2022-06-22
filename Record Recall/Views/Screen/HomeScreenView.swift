//
//  HomeScreenView.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/15/22.
//

import SwiftUI


struct HomeScreenView: View {
    @State private var showingSheet = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        
                        WelcomeMessage()
                        
                        Spacer()
                        SettingsButtonView()
                    }
                    .padding([.bottom, .horizontal])
                    // Data model to send recent records or some other UI if recent records is empty
                    RecentRecords()
                    
                    // History
                    CondensedHistoryView()
                }
            }
        }
        .background(Color.backgroundBlue)
    }
}


struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
