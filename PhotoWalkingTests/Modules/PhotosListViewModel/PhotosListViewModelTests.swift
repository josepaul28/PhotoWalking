//
//  PhotosListViewModelTests.swift
//  PhotoWalkingTests
//
//  Created by Paul Soto on 25/6/22.
//

import XCTest
import Combine
@testable import PhotoWalking

class PhotosListViewModelTests: XCTestCase {
    let photoRepositoryMock: PhotoRepositoryMock = .init()
    let locationManagerMock: LocationManagerMock = .init()
    private var subscriptions: Set<AnyCancellable> = .init()

    lazy var sut: PhotosListViewModel = .init(repository: photoRepositoryMock, locationManager: locationManagerMock)

    func testGivenInitialIsLoadingFalseWhenStartThenIsLoadingTrue() throws {
        locationManagerMock.isLocating = false

        sut.start()

        XCTAssertTrue(sut.isLocating)
    }

    func testGivenInitialIsLoadingTrueWhenStopThenIsLoadingFalse() throws {
        locationManagerMock.isLocating = true

        sut.stop()

        XCTAssertFalse(sut.isLocating)
    }

    func testGivenExpectedPhotoWhenGetPhotosThenMatch() async {
        let expected = PhotoBuilder().build()
        photoRepositoryMock.photos = [expected]
        await sut.getPhotos()
        XCTAssertEqual(sut.photos, [expected])
    }

    func testGivenErrorWhenGetPhotosThenMatchEmptyPhotos() async {
        let expected = PhotoBuilder().build()
        photoRepositoryMock.photos = [expected]
        photoRepositoryMock.error = .random
        await sut.getPhotos()
        XCTAssertEqual(sut.photos, [])
    }

    func testGivenExpectedPhotoWhenNewLocationThenMatch() {
        locationManagerMock.locationSubject = .init()
        let expected = PhotoBuilder().build()
        photoRepositoryMock.photo = expected

        let expectation = self.expectation(description: #function)
        var resultPhotos: [Photo]?

        sut.$photos.dropFirst().sink { photos in
            resultPhotos = photos
            expectation.fulfill()
        }.store(in: &subscriptions)

        let coordinate = CoordinateBuilder()
            .latitude(23.993939)
            .longitude(-21.3234)
            .build()
        locationManagerMock.locationSubject?.send(coordinate)

        wait(for: [expectation], timeout: 0.5)

        XCTAssertEqual(resultPhotos, [expected])
    }

    func testGivenErrorWhenNewLocationThenMatchEmptyPhotos() {
        locationManagerMock.locationSubject = .init()
        let expected = PhotoBuilder().build()
        photoRepositoryMock.photo = expected
        photoRepositoryMock.error = .random

        let expectation = self.expectation(description: #function)
        expectation.isInverted = true
        var resultPhotos: [Photo]?

        sut.$photos.dropFirst().sink { photos in
            resultPhotos = photos
            expectation.fulfill()
        }.store(in: &subscriptions)

        let coordinate = CoordinateBuilder()
            .latitude(23.993939)
            .longitude(-21.3234)
            .build()
        locationManagerMock.locationSubject?.send(coordinate)

        wait(for: [expectation], timeout: 0.5)

        XCTAssertNil(resultPhotos)
    }
}
