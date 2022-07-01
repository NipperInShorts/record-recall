//
//  RepsInputView.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/21/22.
//

import SwiftUI
import Combine

struct RepsInputView: View {
    @ObservedObject var viewModel: AddRecordViewModel
    @State private var internalReps = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Enter your reps")
                .bold()
                .foregroundColor(.primaryBlue)
            TextField("1, 3, 5", text:  $internalReps)
                .onReceive(Just(internalReps), perform: { newValue in
                    internalReps = Helper.repValidator(newValue: newValue, reps: self.internalReps)
                })
                .onChange(of: internalReps, perform: { newValue in
                    viewModel.reps = internalReps
                })
                .onReceive(viewModel.$reps, perform: { newValue in
                    if newValue.isEmpty {
                        internalReps = ""
                    }
                })
                .keyboardType(.decimalPad)
                .padding()
                .foregroundColor(.primaryBlue)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondaryBlue, lineWidth: 1)
                )
                .background(
                    Color.highlightBlue
                        .cornerRadius(8)
                )
            
        }
    }
}


struct RepsInputView_Previews: PreviewProvider {
    static var previews: some View {
        RepsInputView(viewModel: AddRecordViewModel())
    }
}
