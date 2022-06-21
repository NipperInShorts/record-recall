//
//  TextExt.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/13/22.
//

import SwiftUI

extension Text {
    func modifyColor() -> some View {
        self.modifier(ColorModifier())
    }
}
