//
//  Record_RecallApp.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/13/22.
//

import SwiftUI

@main
struct Record_RecallApp: App {
    let storageProvider = StorageProvider.storageProvider
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, storageProvider.persistentContainer.viewContext)
        }
    }
}
