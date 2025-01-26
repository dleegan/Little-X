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
            VStack {
                postsCells
            }
            .frame(maxWidth: .infinity)
            .overlay(content: {
                if posts.isEmpty {
                    ContentUnavailableView {
                        Label("No posts found", systemImage: "text.page.slash")
                    } description: {
                        Text("No posts found. Please add a new one.")
                    }
                    .background()
                }
            })
            .overlay(content: {
                VStack { newPostButton }
                    .padding(.horizontal)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .bottomTrailing
                    )
            })
            .overlay(content: {
                if selectedUser?.userId == nil {
                    ContentUnavailableView {
                        Label("No user selected", systemImage: "person.crop.circle.badge.exclamationmark")
                    } description: {
                        Text("No user selected. Please select one.")
                    }
                    .background()
                }
            })
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
            selectedUser = usr

            print(posts)
        }
    }

    private var postsCells: some View {
        ScrollView {
            VStack(spacing: 30) {
                ForEach(posts) { post in
                    PostCell(post: post, selectedUser: $selectedUser)
                }
            }
            .padding()
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
