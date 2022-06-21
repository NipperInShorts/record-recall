//
//  Modifiers.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/13/22.
//

import SwiftUI

struct ColorModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
    }
}
