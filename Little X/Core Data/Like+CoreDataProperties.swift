//
//  Like+CoreDataProperties.swift
//  Little X
//
//  Created by dleegan on 24/01/2025.
//
//

import Foundation
import CoreData


extension Like {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Like> {
        return NSFetchRequest<Like>(entityName: "Like")
    }

    @NSManaged public var date: Date?
    @NSManaged public var user: User?

}

extension Like : Identifiable {

}
