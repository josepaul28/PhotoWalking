//
//  Persistence.swift
//
//  Created by Paul Soto on 24/6/22.
//

import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    internal let container: NSPersistentContainer
    private(set) var isAvailable: Bool = false

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PhotoWalking")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { [weak self] (storeDescription, error) in
            guard error == nil else {
                self?.isAvailable = false
                return
            }
            self?.isAvailable = true
            self?.container.viewContext.automaticallyMergesChangesFromParent = true
        })
    }
}
