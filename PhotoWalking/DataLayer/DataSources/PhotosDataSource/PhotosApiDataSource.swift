//
//  PhotosApiDataSource.swift
//
//  Created by PAUL SOTO on 30/6/21.
//

import Foundation

final class PhotosApiDataSource: PhotosDataSource {
    lazy var api: DataTransferService = {
        let apiDataNetwork = DefaultNetworkService(config: ApiDataNetworkConfig())
        return DefaultDataTransferService(with: apiDataNetwork)
    }()

    func fetchPhotos(location: Coordinate) async throws -> [Photo] {
        let params: [String: Any] = [
            "media": "photos",
            "content_type": 1,
            "geo_context": 2,
            "lat": location.latitude,
            "lon": location.longitude,
            "radius": 1,
            "per_page": 1
        ]
        let endpoint = APIEndpoints.getPhotos()
        endpoint.queryParameters.merge(params, uniquingKeysWith: {
            (current, _) in current }
        )
        return try await withCheckedThrowingContinuation { continuation in
            self.api.request(with: endpoint) { (result: Result<FetchPhotosDTO.Result, AppError.DataTransferError>) in
                continuation.resume(with: Result {
                    let data = try result.get()
                    return data.photos.photo
                })
            }
        }
    }
}
