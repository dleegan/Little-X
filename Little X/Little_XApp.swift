//
//  Little_XApp.swift
//  Little X
//
//  Created by dleegan on 24/01/2025.
//

import SwiftUI

@main
struct Little_XApp: App {
    @StateObject private var dataController = DataController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(
                    \.managedObjectContext,
                    dataController.container.viewContext
                )
        }
    }
}
