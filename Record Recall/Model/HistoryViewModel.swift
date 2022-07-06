//
//  HistoryViewModel.swift
//  Record Recall
//
//  Created by Justin Nipper on 7/6/22.
//

import Foundation


class HistoryViewModel: ObservableObject {
    
    let viewContext = StorageProvider.shared.persistentContainer.viewContext
    
    func deleteRecord(_ record: Record) {
        do {
            viewContext.delete(record)
            try viewContext.save()
        } catch {
            print("unable to save", error.localizedDescription)
        }
    }
}
