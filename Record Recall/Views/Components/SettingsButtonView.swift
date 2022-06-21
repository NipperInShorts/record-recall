//
//  SettingsButtonView.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/14/22.
//

import SwiftUI


struct SettingsButtonView: View {
    var body: some View {
        Button {
            print("go to settings")
        } label: {
            Image(systemName: "gearshape")
                .foregroundColor(.primaryBlue)
                .font(.system(size: 20, weight: .medium))
                .padding(8)
                .background(Color.highlightBlue)
                .clipShape(
                    Circle()
                ).shadow(color: .secondaryBlue.opacity(0.5), radius: 3, x: 2, y: 2)
        }
        .buttonStyle(.plain)
    }
}


struct SettingsButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsButtonView()
    }
}
