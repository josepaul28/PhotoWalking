//
//  PhotosDataSource.swift
//
//  Created by PAUL SOTO on 30/6/21.
//

import Foundation

// Remote data sources protocol
protocol PhotosDataSource {
    func fetchPhotos(location: Coordinate) async throws -> [Photo]
}

// Local data sources protocol
protocol PhotosCachedDataSource {
    func fetchPhotos() async throws -> [Photo]
    func savePhoto(_ photo: Photo) async throws
}
