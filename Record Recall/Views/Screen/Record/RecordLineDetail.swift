//
//  RecordLineDetail.swift
//  Record Recall
//
//  Created by Justin Nipper on 7/1/22.
//

import SwiftUI

struct RecordLineDetail: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = AddRecordViewModel()
    @State private var errorMessage = ""
    
    var record: Record
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    // input weight
                    WeightInputView(viewModel: viewModel)
                    
                    // input reps
                    RepsInputView(viewModel: viewModel)
                }
                
                
                DateInputView(viewModel: viewModel)
                    
                
                // add note
                VStack(alignment: .leading, spacing: 8) {
                    Text("Notes:")
                        .bold()
                        .foregroundColor(.primaryBlue)
                    TextEditor(text: $viewModel.notes)
                        .frame(height: 200)
                        .lineSpacing(4)
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        .colorMultiply(Color.highlightBlue)
                        .foregroundColor(.primaryBlue)
                        .background(Color.highlightBlue)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 8)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondaryBlue, lineWidth: 1)
                        )
                    
                }
                
                Button {
                    updateRecord()
                } label: {
                    PrimaryButton(text: "Save Record")
                }
                .padding(.bottom, !errorMessage.isEmpty ? 0 : 16)
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.system(size: 12, weight: .semibold))
                        .font(.callout)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, -10)
                }
            }
            .onAppear {
                viewModel.initializeView(with: record)
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()

                    Button("Done") {
                        self.endTextEditing()
                    }
                }
            }
            .onTapGesture {
                self.endTextEditing()
            }
            .padding(.horizontal)
        }
        .navigationTitle("Edit \(record.exercise?.name ?? "") Record")
        .background(Color.backgroundBlue)
    }
    
    func updateRecord() {
        do {
            try viewModel.updateData(record: record)
            dismiss()
        } catch {}
    }
}
