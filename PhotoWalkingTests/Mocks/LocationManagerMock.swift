//
//  LocationManagerMock.swift
//  PhotoWalkingTests
//
//  Created by Paul Soto on 25/6/22.
//

import XCTest
import Combine
@testable import PhotoWalking

class LocationManagerMock: LocationManager {
    var isLocating: Bool = false
    var authorizationStatus: Status = .notDetermined

    var locationSubject: PassthroughSubject<Coordinate, Never>?
    var locationStatusSubject: PassthroughSubject<Status, Never>?

    func start() {
        isLocating = true
    }

    func stop() {
        isLocating = false
    }
}
