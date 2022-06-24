//
//  PhotoWalkingApp.swift
//  PhotoWalking
//
//  Created by Paul Soto on 24/6/22.
//

import SwiftUI

@main
struct PhotoWalkingApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
