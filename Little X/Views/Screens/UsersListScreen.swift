//
//  UsersListView.swift
//  Little X
//
//  Created by dleegan on 24/01/2025.
//

import SwiftUI

struct UsersListScreen: View {
    @Environment(\.dismiss) var dismiss
    @FetchRequest(sortDescriptors: []) var users: FetchedResults<User>
    @Binding var selectedUser: User?
    @State private var showNewUserView: Bool = false

    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 30) {
                ForEach(users) { user in
                    UserProfileCell(
                        user: user,
                        isSelected: .constant(true)
                    )
                    .onTapGesture {
                        UserDefaults.standard.set(user.userId?.uuidString, forKey: "userId")
                        selectedUser = user
                        dismiss()
                    }
                }

                addUserButton
            }
            .padding(.vertical, 40)
            .sheet(isPresented: $showNewUserView) {
                NewUserScreen()
            }
        }
    }

    private var addUserButton: some View {
        Button {
            showNewUserView.toggle()
        } label: {
            VStack {
                Image(systemName: "plus")
                    .foregroundStyle(Color(white: 0.9))
                    .scaleEffect(2)
                    .frame(width: 80, height: 80)
                    .clipShape(
                        Circle()
                    )
                    .padding(6)
                    .overlay {
                        Circle()
                            .strokeBorder(
                                Color(white: 0.9),
                                lineWidth: 4
                            )
                    }

                Text("New User")
                    .bold()
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    UsersListScreen(selectedUser: .constant(User.preview))
        .environment(
            \.managedObjectContext,
            DataController.preview.container.viewContext
        )
}
