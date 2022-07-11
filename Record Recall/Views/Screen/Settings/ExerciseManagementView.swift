//
//  ExerciseManagementView.swift
//  Record Recall
//
//  Created by Justin Nipper on 7/10/22.
//

import SwiftUI

struct ExerciseManagementView: View {
    @StateObject var viewModel = AddExerciseViewModel()
    @State private var showPopover = false
    @State private var isShowingDeleteAction = false
    @Environment(\.dismiss) var dismiss
    @FetchRequest(fetchRequest: Exercise.allExercises)
    var exercises: FetchedResults<Exercise>
    var body: some View {
        VStack {
            if exercises.isEmpty {
                EmptyScreenMessage(title: "Glad you're here.", message: "The exercise list is empty.\nYou can add exercises by using the plus button at the top.")
            } else {
                List {
                    ForEach(exercises) { exercise in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(exercise.name!)
                                    .foregroundColor(.primaryBlue)
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                isShowingDeleteAction = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .confirmationDialog("Deleting Exercise Removes Records", isPresented: $isShowingDeleteAction) {
                            Button(role: .destructive) {
                                delete(exercise: exercise)
                                isShowingDeleteAction = false
                            } label: {
                                Text("Delete")
                            }
                            Button(role: .cancel) {
                                //handle delete
                                isShowingDeleteAction = false
                            } label: {
                                Text("Cancel")
                            }
                        } message: {
                            Text("Deleting the exercises removes associated records")
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
            AddSettingsExerciseView(showing: $showPopover, viewModel: viewModel)
        }
    }
    
    func delete(exercise: Exercise) {
        viewModel.deleteExercise(exercise)
    }
}

struct ExerciseManagementView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseManagementView()
    }
}
