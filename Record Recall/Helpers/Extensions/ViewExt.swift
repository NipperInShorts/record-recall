//
//  ViewExt.swift
//  Record Recall
//
//  Created by Justin Nipper on 7/8/22.
//

import SwiftUI
extension View {
  func endTextEditing() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                    to: nil, from: nil, for: nil)
  }
}
