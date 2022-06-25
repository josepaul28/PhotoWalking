//
//  Photo.swift
//
//  Created by PAUL SOTO on 3/7/21.
//

import Foundation

struct Photo: Codable, Identifiable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String

    var imageUrl: URL? {
        let strUrl = Constants.Api.imageUrl
            .replacingOccurrences(of: "{server-id}", with: server)
            .replacingOccurrences(of: "{id}", with: id)
            .replacingOccurrences(of: "{secret}", with: secret)
        return URL(string: strUrl)
    }
}

extension Photo: Equatable {
    static func ==(lhs: Photo, rhs: Photo) -> Bool {
        lhs.id == rhs.id
    }
}
