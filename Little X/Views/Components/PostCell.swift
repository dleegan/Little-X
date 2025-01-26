//
//  PostCell.swift
//  Little X
//
//  Created by dleegan on 25/01/2025.
//

import SwiftUI

struct PostCell: View {
    @Environment(\.managedObjectContext) var context

    @ObservedObject var post: Post

    @Binding var selectedUser: User?

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            VStack {
                AsyncImage(url: post.author?.imageUrl) { image in
                    image
                        .resizable()
                } placeholder: {
                    Rectangle()
                        .foregroundStyle(.gray)
                }
            }
            .frame(width: 40, height: 40)
            .clipShape(
                Circle()
            )

            VStack(alignment: .leading, spacing: 10) {
                Text(post.title ?? "No title found")
                    .bold()
                Text(post.content ?? "No description found")
                    .foregroundStyle(.secondary)
                    .font(.callout)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button {
                do {
                    let newLike = Like(context: context)
                    newLike.date = .now
                    newLike.user = selectedUser
                    post.addToLikes(newLike)
                    try context.save()
                } catch {
                    print("An Error has occured")
                }
            } label: {
                HStack(spacing: 8) {
                    Text("\(post.likes?.count ?? 0)")
                        .foregroundStyle(.secondary)
                        .font(.callout)
                    Image(systemName: "heart")
                }
            }
        }
    }
}

#Preview {
    PostCell(post: Post.preview, selectedUser: .constant(User.preview))
        .padding()
        .environment(
            \.managedObjectContext,
            DataController.preview.container.viewContext
        )
}
