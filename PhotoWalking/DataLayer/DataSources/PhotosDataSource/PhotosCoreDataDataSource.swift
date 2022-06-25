//
//  PhotosCoreDataDataSource.swift
//
//  Created by Paul Soto on 24/6/22.
//

import Foundation
import CoreData

class PhotosCoreDataDataSource: PhotosCachedDataSource {
    lazy var persitence = PersistenceController.shared

    func fetchPhotos() async throws -> [Photo] {
        guard persitence.isAvailable else {
            throw AppError.Database.notAvailable
        }
        let fetchRequest: NSFetchRequest<PhotoEntity> = PhotoEntity.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(PhotoEntity.createdAt), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        let result = try persitence.container.viewContext.fetch(fetchRequest)
        return result.map({
            .init(id: $0.id ?? "",
                  owner: $0.owner ?? "",
                  secret: $0.secret ?? "",
                  server: $0.server ?? "",
                  farm: Int($0.farm),
                  title: $0.title ?? "")
        })
    }

    func savePhoto(_ photo: Photo) async throws {
        guard persitence.isAvailable else {
            throw AppError.Database.notAvailable
        }
        let pm = persitence.container.newBackgroundContext()
        try await pm.perform {
            let photoEntity = PhotoEntity(context: pm)
            photoEntity.id = photo.id
            photoEntity.owner = photo.owner
            photoEntity.secret = photo.secret
            photoEntity.server = photo.server
            photoEntity.farm = Int64(photo.farm)
            photoEntity.title = photo.title

            try pm.performAndWait {
                if pm.hasChanges {
                    try pm.save()
                }
            }
        }
    }
}

extension PhotoEntity {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        setPrimitiveValue(Date(), forKey: #keyPath(PhotoEntity.createdAt))
    }
}
