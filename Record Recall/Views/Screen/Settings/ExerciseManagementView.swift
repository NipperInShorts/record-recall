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
                    }
                    .onDelete(perform: delete)
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
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let removedExercise = exercises[index]
            viewModel.deleteExercise(removedExercise)
        }
    }
}

struct ExerciseManagementView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseManagementView()
    }
}
