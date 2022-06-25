//
//  Constants.swift
//
//  Created by PAUL SOTO on 30/6/21.
//

import Foundation

struct Constants {
    private init() {}

    struct Api {
        static let apiKey = "88026c272a2aa8233d2de58bdf574956"
        static let `protocol` = "https"
        static let baseUrl = "\(`protocol`)://www.flickr.com/services/rest/"
        static let imageUrl = "https://live.staticflickr.com/{server-id}/{id}_{secret}.jpg"
    }
}
