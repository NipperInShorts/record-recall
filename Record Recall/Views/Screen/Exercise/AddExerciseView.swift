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
        VStack(alignment: .leading) {
            Button {
                viewModel.startAddMachineOver()
                showing.toggle()
            } label: {
                Text("Cancel")
                    .font(.callout)
                    .foregroundColor(.secondaryBlue)
            }

            TextField("Add Exercise", text: $viewModel.exerciseName)
                .focused($nameIsFocused)
                .padding(.vertical)
                .onAppear {
                    nameIsFocused = true
                }
            Button {
                viewModel.addExercise()
                if viewModel.addExerciseStatus == .success {
                    showing = false
                    viewModel.startAddMachineOver()
                }
            } label: {
                PrimaryButton(text: "Add Exercise")
            }
        
            Text(viewModel.addExerciseStatus == .error ? "The exercise cannot be blank" : "")
                .foregroundColor(.red)
                .font(.system(size: 12, weight: .semibold))
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 4)
        }
    }
}

struct AddSettingsExerciseView: View {
    @State private var text = ""
    @Binding var showing: Bool
    @State private var didAttempt: Bool = false
    @ObservedObject var viewModel: AddExerciseViewModel
    @FocusState private var nameIsFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                viewModel.startAddMachineOver()
                showing.toggle()
            } label: {
                Text("Cancel")
                    .font(.callout)
                    .foregroundColor(.secondaryBlue)
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
            
            Text(viewModel.addExerciseStatus == .error ? "The exercise cannot be blank" : "")
                .foregroundColor(.red)
                .font(.system(size: 12, weight: .semibold))
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 4)
        }
    }
}

struct AddExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExerciseView(showing: .constant(true), viewModel: AddRecordViewModel())
    }
}
