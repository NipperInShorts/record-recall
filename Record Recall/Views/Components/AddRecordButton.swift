//
//  AddRecordbutton.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/14/22.
//

import SwiftUI

struct AddRecordButton: View {
    @Binding var showingSheet: Bool
    var body: some View {
        Button {
            showingSheet.toggle()
        } label: {
            Image(systemName: "plus")
                .foregroundColor(.highlightBlue)
                .font(.system(size: 20, weight: .medium))
                .padding(8)
                .background(Color.primaryBlue)
                .clipShape(
                    Circle()
                ).shadow(color: .secondaryBlue.opacity(0.5), radius: 3, x: 2, y: 2)
        }
        .buttonStyle(.plain)
        .padding()
        .fullScreenCover(isPresented: $showingSheet) {
            AddRecordView()
        }
    }
}

struct AddRecordbutton_Previews: PreviewProvider {
    static var previews: some View {
        AddRecordButton(showingSheet: .constant(false))
    }
}
