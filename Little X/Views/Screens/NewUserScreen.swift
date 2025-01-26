//
//  NewUserScreen.swift
//  Little X
//
//  Created by dleegan on 24/01/2025.
//

import SwiftUI

struct NewUserScreen: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.dismiss) var dismiss

    @State private var imageUrl: String = ""
    @State private var userName: String = ""

    var body: some View {
        VStack(spacing: 20) {
            TextField("Picture URL", text: $imageUrl)
            TextField("Username", text: $userName)

            confirmButton
        }
        .textFieldStyle(.roundedBorder)
        .padding()
    }

    private var confirmButton: some View {
        Button {
            do {
                let user = User(context: context)
                user.userId = UUID()
                user.userName = userName
                user.imageUrl = URL(string: imageUrl)
                try context.save()
                dismiss()
            } catch {
                print("An error has occured!")
            }
        } label: {
            Text("Create")
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
    NewUserScreen()
        .environment(
            \.managedObjectContext,
            DataController.preview.container.viewContext
        )
}
