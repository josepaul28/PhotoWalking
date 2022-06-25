//
//  FetchPhotosDTO.swift
//
//  Created by PAUL SOTO on 30/6/21.
//

import Foundation

enum FetchPhotosDTO {
    struct Request: Codable {}
    struct Result: Decodable {
        let photos: Photos
    }
}

extension FetchPhotosDTO.Result {
    struct Photos: Decodable {
        let photo: [Photo]
    }
}
