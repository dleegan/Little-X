//
//  Post+CoreDataClass.swift
//  Little X
//
//  Created by dleegan on 24/01/2025.
//
//

import CoreData
import Foundation

@objc(Post)
public class Post: NSManagedObject {
    static let preview: Post = {
        let post = Post(context: DataController.preview.container.viewContext)
        post.author = User.preview
        post.title = "Thiis is the post title!"
        post.content = "This is the content of this post!!"
        return post
    }()
}
