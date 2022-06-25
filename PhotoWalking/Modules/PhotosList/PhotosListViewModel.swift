//
//  PhotosListViewModel.swift
//
//  Created by Paul Soto on 24/6/22.
//

import Foundation
import Combine

final class PhotosListViewModel:  ObservableObject {
    @Published var photos: [Photo] = .init()
    @Published var isLocating: Bool
    @Published var error: Swift.Error?

    private let repository: PhotoRepository
    private let locationManager: LocationManager

    private let locationSubscriber: PassthroughSubject<Coordinate, Never> = .init()
    private let authorizationSubscriber: PassthroughSubject<Status, Never> = .init()
    private var subscriptions: Set<AnyCancellable> = .init()

    init(repository: PhotoRepository,
         locationManager: LocationManager) {
        self.repository = repository
        self.locationManager = locationManager
        self.isLocating = self.locationManager.isLocating
        self.bind()
    }

    private func bind() {
        self.authorizationSubscriber.sink { [weak self] status in
            guard let self = self else { return }
            switch status {
                case .authorizedWhenInUse:
                    self.error = Error.authorizedWhenInUse
                case .denied, .restricted, .notDetermined, .unknow:
                    self.error = Error.notAuthorized
                case .authorizedAlways: self.error = nil
            }
        }.store(in: &subscriptions)
        self.locationSubscriber.sink { [weak self] location in
            guard let self = self else { return }
            Task { [weak self] in
                await self?.getPhotos(location: location)
            }
        }.store(in: &subscriptions)

        self.locationManager.locationSubject = self.locationSubscriber
        self.locationManager.locationStatusSubject = self.authorizationSubscriber
    }

    func start() {
        locationManager.start()
        self.isLocating = self.locationManager.isLocating
    }

    func stop() {
        locationManager.stop()
        self.isLocating = self.locationManager.isLocating
    }

    @MainActor func getPhotos() async {
        do {
            let photos = try await self.repository.fetchPhotos()
            self.photos = photos
        } catch let error {
            print(error.localizedDescription)
        }
    }

    @MainActor private func getPhotos(location: Coordinate) async {
        do {
            let photo = try await self.repository.fetchPhoto(
                withLocation: location
            )
            self.photos.insert(photo, at: 0)
        } catch let error {
            print(error.localizedDescription)
        }
    }

    enum Error: Swift.Error, LocalizedError {
        case authorizedWhenInUse
        case notAuthorized

        public var errorDescription: String? {
            switch self {
                case .authorizedWhenInUse:
                    return "Location it's only available while you are using the app. If you want to keep working in background, give us your permission in the app settings."
                case .notAuthorized:
                    return "Location it's not available. Please give us you always permission in the app settings."
            }
        }
    }
}
