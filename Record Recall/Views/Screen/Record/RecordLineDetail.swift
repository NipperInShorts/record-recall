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
    @AppStorage("userUnit") private var userUnitRaw = Unit.imperial.rawValue
    
    var record: Record
    
    private var displayUnit: Unit { Unit(rawValue: userUnitRaw) ?? .imperial }
    
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
                let storedUnit = Unit(rawValue: record.unit ?? Unit.metric.rawValue) ?? .metric
                let kg = record.weight.toKilograms(from: storedUnit)
                let displayValue = kg.fromKilograms(to: displayUnit)
                viewModel.weight = Metric(value: displayValue).formattedValue
                viewModel.unit = displayUnit.rawValue
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
        .onChange(of: userUnitRaw) { _ in
            // Parse current weight string
            let currentString = viewModel.weight
            let currentNumber = Double(currentString) ?? 0
            // Determine the previous unit from viewModel.unit, defaulting to metric
            let previousUnit = Unit(rawValue: viewModel.unit) ?? .metric
            // Convert current display value to kg then to new display unit
            let kg = currentNumber.toKilograms(from: previousUnit)
            let newDisplayUnit = Unit(rawValue: userUnitRaw) ?? .imperial
            let newValue = kg.fromKilograms(to: newDisplayUnit)
            viewModel.weight = Metric(value: newValue).formattedValue
            viewModel.unit = newDisplayUnit.rawValue
        }
        .navigationTitle("Edit \(record.exercise?.name ?? "") Record")
        .background(Color.backgroundBlue)
    }
    
    func updateRecord() {
        do {
            record.unit = displayUnit.rawValue
            try viewModel.updateData(record: record)
            dismiss()
        } catch {}
    }
}

