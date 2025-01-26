//
//  NewPostView.swift
//  Little X
//
//  Created by dleegan on 24/01/2025.
//

import SwiftUI

struct NewPostScreen: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.dismiss) var dismiss
    @Binding var selectedUser: User?

    var body: some View {
        VStack(spacing: 20) {
            TextField("Title", text: .constant(""))
            TextField("Content", text: .constant(""))

            confirmButton
        }
        .textFieldStyle(.roundedBorder)
        .padding()
    }

    private var confirmButton: some View {
        Button {
            print("")
        } label: {
            Text("Post")
        }
        .bold()
        .padding()
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .background(.blue)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    NewPostScreen(selectedUser: .constant(User.preview))
        .environment(
            \.managedObjectContext,
            DataController.preview.container.viewContext
        )
}
