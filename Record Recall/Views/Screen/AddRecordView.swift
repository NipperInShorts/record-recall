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

enum Unit {
    case metric, imperial
}


struct AddRecordView: View {
    
    @StateObject private var viewModel = AddRecordViewModel()
    @State private var internalReps = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
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
                        .padding(.bottom)
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
        viewModel.saveData()
    }
}

struct FooterView: View {
    var lift: String = ""
    var body: some View {
        lift.isEmpty ? nil : Button(action: {
            print("Add \(lift)")
        }, label: {
            Label("Add \(lift)", systemImage: "plus")
        })
        .listRowBackground(Color.clear)
        .listRowSeparatorTint(.secondaryBlue)
        .listRowSeparator(.hidden, edges: .top)
    }
}

struct AddRecordView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecordView()
    }
}

