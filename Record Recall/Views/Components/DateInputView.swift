//
//  DateInputView.swift
//  Record Recall
//
//  Created by Justin Nipper on 7/5/22.
//

import Foundation
import SwiftUI


struct DateInputView: View {
    @StateObject var viewModel: AddRecordViewModel
    var body: some View {
        DatePicker(selection: $viewModel.date) {
            Text("Date achieved:")
                .bold()
                .foregroundColor(.primaryBlue)
        }
    }
}
