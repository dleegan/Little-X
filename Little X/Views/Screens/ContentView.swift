//
//  ContentView.swift
//  Little X
//
//  Created by dleegan on 24/01/2025.
//

import SwiftUI

struct ContentView: View {
    @FetchRequest(sortDescriptors: []) var posts: FetchedResults<Post>
    @FetchRequest(sortDescriptors: []) var users: FetchedResults<User>
    @Environment(\.managedObjectContext) var context

    @State private var showUserList: Bool = false
    @State private var showNewPostView: Bool = false
    @State private var profilePicture: URL? = nil

    @State private var selectedUser: User? = nil

    var body: some View {
        NavigationStack {
            postsCells
                .overlay(content: {
                    if posts.isEmpty {
                        ContentUnavailableView {
                            Label("No user selelcted", systemImage: "text.page.slash")
                        } description: {
                            Text("No user selelcted. Please select one.")
                        } actions: {
                            Button {
                                showUserList.toggle()
                            } label: {
                                Text("Select a user")
                                    .bold()
                            }
                            .foregroundStyle(.white)
                            .padding()
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .background()
                    }
                })
//                .overlay(content: {
//                    if posts.isEmpty {
//                        ContentUnavailableView {
//                            Label("No user selelcted", systemImage: "person.crop.circle.badge.exclamationmark")
//                        } description: {
//                            Text("No user selelcted. Please select one.")
//                        } actions: {
//                            Button {
//                                showUserList.toggle()
//                            } label: {
//                                Text("Select a user")
//                                    .bold()
//                            }
//                            .foregroundStyle(.white)
//                            .padding()
//                            .background(.blue)
//                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                        }
//                        .background()
//                    }
//                })
                .overlay(
                    alignment: .bottomTrailing,
                    content: {
                        newPostButton
                            .padding(.horizontal)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .trailing
                            )
                    }
                )
                .navigationTitle("Fil d'actu")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        userListButton
                    }
                }
        }
        .sheet(isPresented: $showUserList) {
            UsersListScreen(selectedUser: $selectedUser)
        }
        .sheet(isPresented: $showNewPostView) {
            NewPostScreen(selectedUser: $selectedUser)
        }
        .onAppear {
            guard let userId = UserDefaults.standard.object(forKey: "userId") as? String else {
                print("No userId found")
                return
            }
            guard let usr = users.first(where: { $0.userId?.uuidString == userId }) else {
                print("an error as occured")
                return
            }
            print("user found")
            print(usr)
            selectedUser = usr
        }
    }

    private var postsCells: some View {
        List {
            ForEach(posts) { post in
                PostCell(post: post)
            }
        }
        .scrollIndicators(.hidden)
    }

    private var userListButton: some View {
        Button {
            showUserList.toggle()
        } label: {
            if selectedUser?.imageUrl != nil {
                VStack {
                    AsyncImage(url: selectedUser?.imageUrl) { image in
                        image
                            .resizable()
                    } placeholder: {
                        Rectangle()
                            .foregroundStyle(.gray)
                    }
                }
                .frame(width: 30, height: 30)
                .clipShape(
                    Circle()
                )
            } else {
                Image(systemName: "person.crop.circle.fill.badge.plus")
                    .imageScale(.large)
            }
        }
    }

    private var newPostButton: some View {
        Button {
            showNewPostView.toggle()
        } label: {
            Image(systemName: "plus")
                .imageScale(.large)
                .tint(.white)
        }
        .padding()
        .background(.blue)
        .clipShape(
            Circle()
        )
        .shadow(radius: 5.0)
    }
}

#Preview {
    ContentView()
        .environment(
            \.managedObjectContext,
            DataController.preview.container.viewContext
        )
}
