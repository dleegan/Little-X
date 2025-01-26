//
//  NewUserScreen.swift
//  Little X
//
//  Created by dleegan on 24/01/2025.
//

import SwiftUI

struct EditUserScreen: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.dismiss) var dismiss

    @ObservedObject var user: User

    @Binding var selectedUser: User?
    @State private var imageUrl: String = ""
    @State private var userName: String = ""

    var body: some View {
        VStack(spacing: 20) {
            profilePicture

            TextField("Picture URL", text: $imageUrl)
            TextField("Username", text: $userName)

            confirmButton
        }
        .textFieldStyle(.roundedBorder)
        .padding()
        .onAppear {
            print("EditUserScreen")
            print(user)
            imageUrl = user.imageUrl?.absoluteString ?? ""
            userName = user.userName ?? ""
        }
    }

    private var confirmButton: some View {
        Button {
            do {
                user.userName = userName
                user.imageUrl = URL(string: imageUrl)
                try context.save()
                if selectedUser?.userId == user.userId {
                    print("Is the same id")
                    selectedUser = user
                }
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

    private var profilePicture: some View {
        VStack {
            AsyncImage(url: URL(string: imageUrl)) { image in
                image
                    .resizable()
            } placeholder: {
                Rectangle()
                    .foregroundStyle(.gray)
            }
        }
        .frame(width: 200, height: 200)
        .clipShape(
            Circle()
        )
        .padding(6)
        .overlay {
            Circle()
                .strokeBorder(
                    AngularGradient(
                        colors: [.red, .pink, .purple, .yellow, .red],
                        center: .center
                    ),
                    lineWidth: 4
                )
        }
    }
}

#Preview {
    EditUserScreen(user: User.preview, selectedUser: .constant(User.preview))
        .environment(
            \.managedObjectContext,
            DataController.preview.container.viewContext
        )
}
