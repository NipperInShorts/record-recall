//
//  ContactLink.swift
//  Record Recall
//
//  Created by Justin Nipper on 7/6/22.
//

import SwiftUI


struct ContactLink: View {
    var icon: String
    var message: String
    var link: String
    var body: some View {
        HStack {
            Image(systemName: icon)
            Link(message,
                 destination: URL(string: link)!
            )
        }
        .lineLimit(1)
        .minimumScaleFactor(0.80)
        .font(.system(size: 14, weight: .semibold))
    }
}

struct ContactLink_Previews: PreviewProvider {
    static var previews: some View {
        ContactLink(icon: "paperplane", message: "Nice Link", link: "https://twitter.com/nipperinshorts")
    }
}
