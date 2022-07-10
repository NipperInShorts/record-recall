//
//  SettingsView.swift
//  Record Recall
//
//  Created by Justin Nipper on 7/6/22.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    @State private var showEmail = false
    @State private var email = SupportEmail(
        toAddress: "nipper@shortsgamestrong.com",
        subject: "Support Email",
        messageHeader: "Please describe your issue below")
    
    var body: some View {
             let settingsView = Form {
                Text("Manage Exercises")
                Text("Set default unit")
                Text("Something about Feedback")
                Text("Something about Removing Ads")
                Section {
                    ContactLink(icon: "link", message: "Reach out on Twitter @NipperInShorts", link: "https://www.twitter.com/nipperinshorts")
                    ContactLink(icon: "link", message: "Lift with me on Instagram @NipperInShorts", link: "https://www.instagram.com/nipperinshorts/")
                    Button(action: {
                        showEmail.toggle()
                    }, label: {
                        HStack {
                            Image(systemName: "paperplane")
                            Text("Email some feedback")
                        }
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                        .font(.system(size: 14, weight: .semibold))
                    })
                } header: {
                    Text("Contact Me")
                } footer: {
                    Text("Use any of the above links for feedback, comments, questions, or to keep in touch about new updates or releases.")
                }
                .sheet(isPresented: $showEmail) {
                    MailView(supportEmail: $email) { result in
                        switch result {
                        case .success:
                            break
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                    }
                }
            }
            .navigationTitle("Settings")
        
        if #available(iOS 16, *) {
            NavigationStack {
                settingsView
            }
        } else {
            NavigationView {
                settingsView
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
