//
//  ExercisePickerView.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/15/22.
//

import SwiftUI

struct ExercisePickerView: View {
    @ObservedObject var viewModel: AddRecordViewModel
    @State private var showPopover = false
    @Environment(\.dismiss) var dismiss
    @FetchRequest(fetchRequest: Exercise.allExercises)
    var exercises: FetchedResults<Exercise>
    var body: some View {
        VStack {
            if exercises.isEmpty {
                EmptyScreenMessage(title: "Glad you're here.", message: "The exercise list is empty.\nYou can add exercises by using the plus button at the top.")
            } else {
                List(exercises) { exercise in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(exercise.name!)
                                .foregroundColor(.primaryBlue)
                            Spacer()
                            if (viewModel.exercise == exercise) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.darkBlue)
                            }
                        }
                    }
                    //hack to make onTap fill full cell of list
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if viewModel.exercise == exercise {
                            viewModel.setExercise(exercise: nil)
                        } else {
                            viewModel.setExercise(exercise: exercise)
                        }
                    }
                }
            }
        }
        .onAppear {
            let appearance = UITableView.appearance()
            appearance.backgroundColor = UIColor(Color.backgroundBlue)
        }
        .background(Color.backgroundBlue)
        .navigationTitle("Exercises")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading:
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Back")
                    }
                },
            trailing:
                Button  {
                    showPopover.toggle()
                } label: {
                    Image(systemName: "plus")
                }
        )
        .disabled(showPopover)
        .toolbarPopover(show: $showPopover) {
            AddExerciseView(showing: $showPopover, viewModel: viewModel)
        }
    }
}

struct ExercisePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisePickerView(viewModel: AddRecordViewModel())
    }
}
