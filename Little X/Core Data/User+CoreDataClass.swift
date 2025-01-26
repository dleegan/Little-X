//
//  User+CoreDataClass.swift
//  Little X
//
//  Created by dleegan on 24/01/2025.
//
//

import CoreData
import Foundation

@objc(User)
public class User: NSManagedObject {
    static let preview: User = {
        let user = User(context: DataController.preview.container.viewContext)
        user.userId = UUID()
        user.userName = "Leegan"
        user.imageUrl = URL(string: "https://randomuser.me/api/portraits/men/52.jpg")
        return user
    }()
}
