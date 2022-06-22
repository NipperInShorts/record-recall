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
    @FetchRequest(fetchRequest: Record.allRecords)
    var records: FetchedResults<Record>
    let double = Double("140")
    var body: some View {
        VStack {
            if exercises.isEmpty {
                VStack(spacing: 8) {
                    Text("Glad you're here.")
                        .bold()
                    Text("The exercise list is empty.\nYou can add exercises by using the plus button at the top.")
                }
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .rotationEffect(Angle(degrees: -15))
                .padding()
                .shadow(color: .primaryBlue.opacity(0.2), radius: 5, x: 5, y: 5)
                .shadow(color: .primaryBlue.opacity(0.2), radius: 5, x: -5, y: -5)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
