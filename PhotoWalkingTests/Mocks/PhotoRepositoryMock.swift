//
//  PhotoRepositoryMock.swift
//  PhotoWalkingTests
//
//  Created by Paul Soto on 25/6/22.
//

import XCTest
@testable import PhotoWalking

class PhotoRepositoryMock: PhotoRepository {
    enum Error: Swift.Error {
        case random
    }
    var photos: [Photo] = .init()
    var photo: Photo?
    var error: Error?

    func fetchPhoto(withLocation location: Coordinate) async throws -> Photo {
        guard let error = error else {
            guard let photo = photo else {
                throw Error.random
            }
            return photo
        }
        throw error
    }

    func fetchPhotos() async throws -> [Photo] {
        guard let error = error else {
            return photos
        }
        throw error
    }
}
