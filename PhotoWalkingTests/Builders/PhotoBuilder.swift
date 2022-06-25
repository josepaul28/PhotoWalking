//
//  PhotoBuilder.swift
//  PhotoWalkingTests
//
//  Created by Paul Soto on 25/6/22.
//

import Foundation
@testable import PhotoWalking

final class PhotoBuilder {
    private var id: String = "763763"
    private var owner: String = "32443FGK"
    private var secret: String = "333444"
    private var server: String = "445554"
    private var farm: Int = 444444
    private var title: String = "Title"

    func id(_ param: String) -> Self {
        id = param
        return self
    }

    func owner(_ param: String) -> Self {
        owner = param
        return self
    }

    func secret(_ param: String) -> Self {
        secret = param
        return self
    }

    func server(_ param: String) -> Self {
        server = param
        return self
    }

    func farm(_ param: Int) -> Self {
        farm = param
        return self
    }

    func title(_ param: String) -> Self {
        title = param
        return self
    }

    func build() -> Photo {
        .init(id: id,
              owner: owner,
              secret: secret,
              server: server,
              farm: farm,
              title: title)
    }
}
