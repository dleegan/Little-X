//
//  DataController.swift
//  Little X
//
//  Created by dleegan on 24/01/2025.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container: NSPersistentContainer

    static let shared = DataController()
    static let preview = DataController(inMemory: true)

    init(inMemory: Bool = false) {
        self.container = NSPersistentContainer(name: "MyDatabase")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error {
                print("Core data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
