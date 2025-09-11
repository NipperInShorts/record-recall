//
//  AddExerciseView.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/20/22.
//

import SwiftUI

struct AddExerciseView: View {
    @State private var text = ""
    @Binding var showing: Bool
    @State private var didAttempt: Bool = false
    @ObservedObject var viewModel: AddRecordViewModel
    @FocusState private var nameIsFocused: Bool
        
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Button {
                    viewModel.startAddMachineOver()
                    showing.toggle()
                } label: {
                    Text("Cancel")
                        .font(.callout)
                        .foregroundColor(.secondaryBlue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            TextField("Add Exercise", text: $viewModel.exerciseName)
                .focused($nameIsFocused)
                .padding(.vertical)
                .onAppear {
                    nameIsFocused = true
                }
           
            Button {
                if viewModel.exercise != nil {
                    viewModel.saveExercise()
                } else {
                    viewModel.addExercise()
                }
                if viewModel.addExerciseStatus == .success {
                    viewModel.startAddMachineOver()
                    showing = false
                }
            } label: {
                PrimaryButton(text: viewModel.exercise != nil ? "Update Exercise" : "Add Exercise")
            }
            .frame(maxWidth: 200, alignment: .center)
        
            Text(viewModel.addExerciseStatus == .error ? "The exercise cannot be blank" : "")
                .foregroundColor(.red)
                .font(.system(size: 12, weight: .semibold))
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 4)
        }
        .padding()
        .presentationCompactAdaptation(.popover)
    }
}

struct AddSettingsExerciseView: View {
    @State private var text = ""
    @Binding var showing: Bool
    @State private var didAttempt: Bool = false
    @ObservedObject var viewModel: AddExerciseViewModel
    @FocusState private var nameIsFocused: Bool
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Button {
                    viewModel.startAddMachineOver()
                    showing.toggle()
                } label: {
                    Text("Cancel")
                        .font(.callout)
                        .foregroundColor(.secondaryBlue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            TextField("Add Exercise", text: $viewModel.exerciseName)
                .focused($nameIsFocused)
                .padding(.vertical)
                .onAppear {
                    nameIsFocused = true
                }
            Button {
                if viewModel.exercise != nil {
                    viewModel.saveExercise()
                } else {
                    viewModel.addExercise()
                }
                if viewModel.addExerciseStatus == .success {
                    viewModel.startAddMachineOver()
                    showing = false
                }
            } label: {
                PrimaryButton(text: viewModel.exercise != nil ? "Update Exercise" : "Add Exercise")
            }
            .frame(maxWidth: 200, alignment: .center)
            
            Text(viewModel.addExerciseStatus == .error ? "The exercise cannot be blank" : "")
                .foregroundColor(.red)
                .font(.system(size: 12, weight: .semibold))
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 4)
        }
        .padding()
        .presentationCompactAdaptation(.popover)
    }
}

struct AddExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExerciseView(showing: .constant(true), viewModel: AddRecordViewModel())
    }
}
