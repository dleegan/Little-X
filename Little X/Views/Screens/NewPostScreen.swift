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

    @State private var title: String = ""
    @State private var content: String = ""

    var body: some View {
        VStack(spacing: 20) {
            TextField("Title", text: $title)
            TextField("Content", text: $content)

            confirmButton
        }
        .textFieldStyle(.roundedBorder)
        .padding()
    }

    private var confirmButton: some View {
        Button {
            if selectedUser == nil { return }
            do {
                let newPost = Post(context: context)
                newPost.title = title
                newPost.content = content
                newPost.author = selectedUser
                newPost.date = .now
                try context.save()
                dismiss()
            } catch {
                print("An error occured")
            }
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
