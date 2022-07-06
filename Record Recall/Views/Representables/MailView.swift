//
//  MailView.swift
//  Record Recall
//
//  Created by Justin Nipper on 7/6/22.
//

import Foundation
import SwiftUI
import MessageUI


struct SupportEmail {
    let toAddress: String
    let subject: String
    let messageHeader: String
    var body: String {"""
        Application Name: \(Bundle.main.displayName)
        iOS: \(UIDevice.current.systemVersion)
        Device Model: \(UIDevice.current.modelName)
        App Version: \(Bundle.main.appVersion)
        App Build: \(Bundle.main.appBuild)
        \(messageHeader)
    --------------------------------------
    """
    }
    
    func send(openURL: OpenURLAction) {
        let urlString = "mailto:\(toAddress)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")"
        guard let url = URL(string: urlString) else { return }
        openURL(url) { accepted in
            if !accepted {
                print("""
                This device does not support email
                \(body)
                """
                )
            }
        }
    }
}

// Credit for this struct goes to https://swiftuirecipes.com/blog/send-mail-in-swiftui
typealias MailViewCallback = ((Result<MFMailComposeResult, Error>) -> Void)?

struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentation
    @Binding var supportEmail: SupportEmail
    let callback: MailViewCallback
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var presentation: PresentationMode
        @Binding var data: SupportEmail
        let callback: MailViewCallback
        
        init(presentation: Binding<PresentationMode>,
             data: Binding<SupportEmail>,
             callback: MailViewCallback) {
            _presentation = presentation
            _data = data
            self.callback = callback
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            if let error = error {
                callback?(.failure(error))
            } else {
                callback?(.success(result))
            }
            $presentation.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(presentation: presentation, data: $supportEmail, callback: callback)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let mvc = MFMailComposeViewController()
        mvc.mailComposeDelegate = context.coordinator
        mvc.setSubject(supportEmail.subject)
        mvc.setToRecipients([supportEmail.toAddress])
        mvc.setMessageBody(supportEmail.body, isHTML: false)
        mvc.accessibilityElementDidLoseFocus()
        return mvc
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {
    }
    
    static var canSendMail: Bool {
        MFMailComposeViewController.canSendMail()
    }
}
