//
//  PrimaryButton.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/21/22.
//

import SwiftUI

struct PrimaryButton: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.system(size: 16, weight: .medium))
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(Color.highlightBlue)
            .background(Color.primaryBlue)
            .cornerRadius(8)
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(text: "Do thing")
    }
}
