//
//  WelcomeMessage.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/13/22.
//

import SwiftUI

struct WelcomeMessage: View {
    
    @State private var time: Date = Date()
    
    var hour: Int {
        Calendar.current.component(.hour, from: time)
    }
    
    var body: some View {
        //MARK: Add ability to tell time of day and pick greeting
        VStack(alignment: .leading) {
            Text(Helper.getGreeting(from: hour))
                .foregroundColor(.darkBlue)
                .font(
                    .system(size: 26,weight: .semibold)
                )
                .multilineTextAlignment(.leading)
                .lineLimit(2)
    
//            #if DEBUG
//            DatePicker("Pick a date", selection: $time, displayedComponents: .hourAndMinute)
//                .foregroundColor(.darkBlue)
//                .padding()
//            #endif
        }
        .onAppear {
            time = Date()
        }
    }
}

struct WelcomeMessage_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeMessage()
    }
}
