//
//  CustomAlertView.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/21/22.
//

import SwiftUI

struct CustomAlertView: View {
    var messageText: String
    var action: ()-> Void
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text(messageText)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 40)
                .padding()
                .overlay(Divider(), alignment: .bottom)
            Button {
                self.action()
            } label: {
                Text("OK")
                    .fontWeight(.semibold)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, maxHeight: 50)
            }
            
        }
        .background(Color.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 15, style: .continuous)
        )
        .shadow(color: .primaryBlue.opacity(0.2), radius: 5, x: 5, y: 5)
        .shadow(color: .primaryBlue.opacity(0.2), radius: 5, x: -5, y: -5)
        .padding()
    }
    
}

extension View {
    func customAlert(
        show: Binding<Bool>,
        messageText: String,
        action: @escaping ()-> Void
    ) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack(alignment: .center) {
                    if show.wrappedValue {
                        Color.black.opacity(0.35).edgesIgnoringSafeArea(.all)
                        CustomAlertView(messageText: messageText, action: action)
                    }
                }
            )
    }
}


struct CustomAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlertView(messageText: "Please check what happened and try again", action: {})
    }
}
