//
//  AddRecordView.swift
//  Record Recall
//
//  Created by Justin Nipper on 6/14/22.
//

import SwiftUI
import Combine
import CoreData

enum Unit: String {
    case metric = "metric"
    case imperial = "imperial"
}

extension Double {
    // Converts self from source unit to kilograms
    func toKilograms(from source: Unit) -> Double {
        switch source {
        case .metric:   return self
        case .imperial: return self * 0.45359237
        }
    }
    
    // Converts self from kilograms to target unit
    func fromKilograms(to target: Unit) -> Double {
        switch target {
        case .metric:   return self
        case .imperial: return self / 0.45359237
        }
    }
}

struct AddRecordView: View {
    
    @StateObject private var viewModel = AddRecordViewModel()
    @State private var internalReps = ""
    @State private var errorMessage = ""
    
    var body: some View {
            let addRecord = VStack(alignment: .leading) {
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
                                    Text(viewModel.exercise?.name ?? "Choose a lift")
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
                        .onReceive(NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave, object: viewModel.storageProvider.persistentContainer.viewContext)) { output in
                            if (viewModel.exercise != nil) {
                                viewModel.storageProvider.dismissIfDeleted(output, object: viewModel.exercise!) {
                                    viewModel.exercise = nil
                                    viewModel.exerciseName = ""
                                } onFailure: {}
                            }
                        }
                        .onReceive(NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange, object: viewModel.storageProvider.persistentContainer.viewContext)) { output in
                            if let userInfo = output.userInfo {
                                if let updatedObjects = userInfo[NSManagedObjectContext.NotificationKey.updatedObjects.rawValue] as? Set<NSManagedObject> {
                                    if updatedObjects.contains(where: { $0.objectID == viewModel.exercise?.objectID }) {
                                        viewModel.exercise = nil
                                        viewModel.exerciseName = ""
                                    }
                                }
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
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()

                        Button("Done") {
                            self.endTextEditing()
                        }
                    }
                }
            }
            .navigationTitle("Add Record")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.backgroundBlue)
        if #available(iOS 16, *) {
            NavigationStack {
                addRecord
            }
        } else {
                NavigationView {
                    addRecord
                }
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

