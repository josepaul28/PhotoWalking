//
//  APIEndpoints+Photos.swift
//
//  Created by PAUL SOTO on 30/6/21.
//

import Foundation

extension APIEndpoints {
    static func getPhotos() -> Endpoint<FetchPhotosDTO.Result> {
        let endpoint = Endpoint<FetchPhotosDTO.Result>.init(
            path: "",
            method: .get
        )
        endpoint.queryParameters = [
            "method": "flickr.photos.search"
        ]
        return endpoint
    }
}
