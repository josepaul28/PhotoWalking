//
//  CartRepository.swift
//
//  Created by PAUL SOTO on 3/7/21.
//

import Foundation

protocol PhotoRepository {
    func fetchPhoto(withLocation location: Coordinate) async throws -> Photo
    func fetchPhotos() async throws -> [Photo]
}

public class PhotosRepositoryImpl: PhotoRepository {
    // MARK: Remote Data Sources
    private var api: PhotosDataSource

    // MARK: Local Data Sources
    private var photoDS: PhotosCachedDataSource

    // Exposing convenience init for the clients
    public convenience init() {
        self.init(api: PhotosApiDataSource(),
                  photoDS: PhotosCoreDataDataSource())
    }

    internal init(
        api: PhotosDataSource,
        photoDS: PhotosCachedDataSource
    ) {
        self.api = api
        self.photoDS = photoDS
    }

    func fetchPhoto(withLocation location: Coordinate) async throws -> Photo {
        guard let photo = try await self.api.fetchPhotos(location: location).first else {
            throw AppError.DataTransferError.noResponse
        }
        try await self.photoDS.savePhoto(photo)
        return photo
    }

    func fetchPhotos() async throws -> [Photo] {
        try await self.photoDS.fetchPhotos()
    }
}
