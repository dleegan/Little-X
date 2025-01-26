//
//  UsersListView.swift
//  Little X
//
//  Created by dleegan on 24/01/2025.
//

import SwiftUI

struct UsersListScreen: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.dismiss) var dismiss
    @FetchRequest(sortDescriptors: []) var users: FetchedResults<User>
    @Binding var selectedUser: User?

    @GestureState private var isDetectingLongPress = false
    @State private var showNewUserView: Bool = false
    @State private var showEditView: Bool = false
    @State private var completedLongPress = false
    @State private var isShowingConfirmationDialog: Bool = false

    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 30) {
                ForEach(users, id: \.self) { user in
                    UserProfileCell(
                        user: user,
                        isSelected: user.userId == selectedUser?.userId
                    )
                    .onTapGesture {
                        UserDefaults.standard.set(user.userId?.uuidString, forKey: "userId")
                        selectedUser = user
                        dismiss()
                    }
                    .gesture(longPress)
                    .confirmationDialog(
                        "More actions: \(user.userName ?? "")",
                        isPresented: $isShowingConfirmationDialog,
                        titleVisibility: .visible
                    ) {
                        Button("Modifier cet utilisateur") {
                            showEditView.toggle()
                        }
                        Button("Supprimer cet utilisateur", role: .destructive) {
                            deleteUser(user: user)
                        }
                        Button("Annuler", role: .cancel) {}
                    }
                    .sheet(isPresented: $showEditView) {
                        EditUserScreen(user: user, selectedUser: $selectedUser)
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

    private var longPress: some Gesture {
        LongPressGesture(minimumDuration: 1)
            .updating($isDetectingLongPress) { currentState, gestureState,
                transaction in
                gestureState = currentState
                transaction.animation = Animation.easeIn(duration: 2.0)
            }
            .onEnded { finished in
                self.completedLongPress = finished
                isShowingConfirmationDialog = true
            }
    }

    private func deleteUser(user: User) {
        do {
            context.delete(user)
            try context.save()
        } catch {
            print("An error occured")
        }
    }
}

#Preview {
    UsersListScreen(selectedUser: .constant(User.preview))
        .environment(
            \.managedObjectContext,
            DataController.preview.container.viewContext
        )
}
