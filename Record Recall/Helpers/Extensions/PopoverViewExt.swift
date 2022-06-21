//
//  PopoverViewExt.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/21/22.
//

import Foundation
import SwiftUI

extension View {
    
    
    func toolbarPopover<Content: View>(show: Binding<Bool>, @ViewBuilder content: @escaping ()-> Content) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack(alignment: .topTrailing) {
                    if show.wrappedValue {
                        Color.black.opacity(0.09).edgesIgnoringSafeArea(.all)
                        content()
                            .padding()
                            .background(Color.white)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                            )
                            .padding()
                            .shadow(color: .primaryBlue.opacity(0.2), radius: 5, x: 5, y: 5)
                            .shadow(color: .primaryBlue.opacity(0.2), radius: 5, x: -5, y: -5)
                    }
                }
            )
    }
}

struct PopoverExt_Previews: PreviewProvider {
    static var previews: some View {
        AddRecordView()
    }
}
