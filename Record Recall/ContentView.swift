//
//  ContentView.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/13/22.
//

import SwiftUI
import AppTrackingTransparency
import GoogleMobileAds

struct ContentView: View {
    var body: some View {
        AppTabView()
            .preferredColorScheme(.light)
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                setupAdsTracking()
            }
        
    }
    
    func setupAdsTracking() {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .notDetermined:
                break
            case .restricted:
                break
            case .denied:
                break
            case .authorized:
                GADMobileAds.sharedInstance().start(completionHandler: nil)
                break
            @unknown default:
                break
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}
