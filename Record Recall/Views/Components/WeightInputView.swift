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
                TextField(viewModel.unit == Unit.metric.rawValue ? "Kilos" : "Pounds", text: $internalWeight)
                    .onReceive(Just(internalWeight), perform: { newValue in
                        internalWeight = Helper.weightValidator(newValue: newValue, weight: self.internalWeight)
                    })
                    .onChange(of: internalWeight, perform: { newValue in
                        viewModel.weight = internalWeight
                    })
                    .onReceive(viewModel.$weight, perform: { newValue in
                        internalWeight = newValue
                    })
                    .keyboardType(.decimalPad)
                    .padding()
                    .foregroundColor(.primaryBlue)

                Text(viewModel.unit == Unit.imperial.rawValue ? "LB" : "KG")
                    .fontWeight(.bold)
                    .foregroundColor(.primaryBlue)
                    .padding(.horizontal)
                    .onReceive(NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)) { _ in
                        viewModel.unit = UserDefaults.standard.string(forKey: "userUnit")!
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
