//
//  AddRecordView.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/14/22.
//

import SwiftUI
import Combine

struct LiftData: Identifiable {
    let id = UUID()
    let name: String
}

enum Unit: String {
    case metric = "metric"
    case imperial = "imperial"
}


struct AddRecordView: View {
    
    @StateObject private var viewModel = AddRecordViewModel()
    @State private var internalReps = ""
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationPicker {
            VStack(alignment: .leading) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(viewModel.exercise != nil ? "New \(viewModel.exercise?.name ?? "") Record" : "New Record")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.darkBlue)
                        
                        // Choose category from list or add new
                        NavigationLink {
                            ExercisePickerView(viewModel: viewModel)
                        } label: {
                            HStack(alignment: .center, spacing: 4) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Your lift")
                                        .foregroundColor(.primaryBlue)
                                        .bold()
                                    Text(viewModel.exercise?.name! ?? "Choose a lift")
                                        .foregroundColor(viewModel.exercise != nil
                                                         ? .secondaryBlue
                                                         : .primaryBlue
                                        )
                                        .font(viewModel.exercise != nil
                                              ? .headline
                                              : .body
                                        )
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondaryBlue)
                            }
                        }
                        
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
                            saveRecord()
                        } label: {
                            PrimaryButton(text: "Add Record")
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
                    .onTapGesture {
                        self.endTextEditing()
                    }
                    .padding(.horizontal)
                }
                
                
            }
            .navigationTitle("Add Record")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.backgroundBlue)
        }
    }
    
    private func saveRecord() -> Void {
        do {
            try viewModel.saveData()
            errorMessage = ""
            internalReps = ""
        } catch AddExerciseError.repsIsEmpty {
            errorMessage = "Reps shouldn't be empty."
        } catch AddExerciseError.exerciseNotSelected {
            errorMessage = "Make sure you select an exercise to associate the record with."
        } catch {
            errorMessage = "Unable to save the record. Try again."
        }
    }
}

struct AddRecordView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecordView()
    }
}

