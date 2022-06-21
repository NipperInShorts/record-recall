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
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                showing.toggle()
            } label: {
                Text("Cancel")
                    .font(.callout)
                    .foregroundColor(.secondaryBlue)
            }

            TextField("Add Exercise", text: $text)
                .padding(.vertical)
            Button {
                StorageProvider().saveExercise(named: text)
            } label: {
                PrimaryButton(text: "Add Exercise")
            }
            .padding(.bottom)
        }
    }
}

struct AddExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExerciseView(showing: .constant(true))
    }
}
