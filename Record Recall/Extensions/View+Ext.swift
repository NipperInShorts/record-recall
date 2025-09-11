//
//  View+Ext.swift
//  Record Recall
//
//  Created by Justin Nipper on 9/11/25.
//

import SwiftUI

struct SafeAddGlassEffectModifier: ViewModifier {
    @ViewBuilder func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .padding()
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 16))
        } else {
            content
        }
    }
}

extension View {
    func safeAddGlassEffect() -> some View {
        self.modifier(SafeAddGlassEffectModifier())
    }
}
