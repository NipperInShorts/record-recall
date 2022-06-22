//
//  WeightInputView.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/21/22.
//

import SwiftUI
import Combine

struct WeightInputView: View {
    @ObservedObject var viewModel: AddRecordViewModel
    @State private var internalWeight = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Weight")
                .bold()
                .foregroundColor(.primaryBlue)
            HStack {
                TextField(viewModel.unit == .metric ? "Kilos" : "Pounds", text: $internalWeight)
                    .onReceive(Just(internalWeight), perform: { newValue in
                        internalWeight = Helper.weightValidator(newValue: newValue, weight: self.internalWeight)
                    })
                    .onChange(of: internalWeight, perform: { newValue in
                        viewModel.weight = internalWeight
                    })
                    .keyboardType(.decimalPad)
                    .padding()
                    .foregroundColor(.primaryBlue)
                
                VStack(spacing: 8) {
                    Button {
                        viewModel.unit = .metric
                    } label: {
                        Text("KG")
                            .fontWeight(viewModel.unit == .metric ? .bold : .regular)
                            .foregroundColor(viewModel.unit == .metric ? .primaryBlue : .secondaryBlue)
                            .padding(.horizontal)
                    }
                    
                    Button {
                        viewModel.unit = .imperial
                    } label: {
                        Text("LB")
                            .fontWeight(viewModel.unit == .imperial ? .bold : .regular)
                            .foregroundColor(viewModel.unit == .imperial ? .primaryBlue : .secondaryBlue)
                            .padding(.horizontal, 9)
                        
                    }
                }
            }
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

struct WeightInputView_Previews: PreviewProvider {
    static var previews: some View {
        WeightInputView(viewModel: AddRecordViewModel())
    }
}
