//
//  HomeScreenView.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/15/22.
//

import SwiftUI


struct HomeScreenView: View {
    
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
                    BannerAd(unitID: "ca-app-pub-8096207827009586/4798997896")
                        .padding(.top, 8)
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
