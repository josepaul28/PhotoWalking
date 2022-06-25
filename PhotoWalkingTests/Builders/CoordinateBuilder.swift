//
//  CoordinateBuilder.swift
//  PhotoWalkingTests
//
//  Created by Paul Soto on 25/6/22.
//

import Foundation
@testable import PhotoWalking

final class CoordinateBuilder {
    private var latitude: Double = 0
    private var longitude: Double = 0

    func latitude(_ param: Double) -> Self {
        latitude = param
        return self
    }

    func longitude(_ param: Double) -> Self {
        longitude = param
        return self
    }

    func build() -> Coordinate {
        .init(latitude: latitude, longitude: longitude)
    }
}
