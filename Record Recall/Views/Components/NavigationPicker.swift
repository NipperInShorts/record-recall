//
//  NavigationPicker.swift
//  Record Recall
//
//  Created by Justin Nipper on 7/6/22.
//

import SwiftUI

struct NavigationPicker<Content: View>: View {
    @ViewBuilder var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        if #available(iOS 16, *) {
            NavigationStack {
                self.content()
            }
        } else {
            NavigationView(content: self.content)
        }
    }
}

struct NavigationPicker_Previews: PreviewProvider {
    static var previews: some View {
        NavigationPicker(content: {
            HStack {
                Text("Nice")
            }
        })
    }
}
