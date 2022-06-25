//
//  LocationManager.swift
//
//  Created by Paul Soto on 24/6/22.
//

import Foundation
import CoreLocation
import Combine

public enum Status {
    case notDetermined
    case authorizedWhenInUse
    case restricted
    case denied
    case authorizedAlways
    case unknow

    init(status: CLAuthorizationStatus) {
        switch status {
            case .notDetermined: self = .notDetermined
            case .restricted: self = .restricted
            case .denied: self = .denied
            case .authorizedAlways: self = .authorizedAlways
            case .authorizedWhenInUse: self = .authorizedWhenInUse
            @unknown default: self = .unknow
        }
    }
}

protocol LocationManager: AnyObject {
    var isLocating: Bool { get }
    var authorizationStatus: Status { get }
    var locationSubject: PassthroughSubject<Coordinate, Never>? { get set }
    var locationStatusSubject: PassthroughSubject<Status, Never>? { get set }

    func start()
    func stop()
}

final class LocationManagerImpl: NSObject, LocationManager {
    private let locationManager: CLLocationManager
    private var currentLocation: CLLocation?

    public weak var locationSubject: PassthroughSubject<Coordinate, Never>?
    public weak var locationStatusSubject: PassthroughSubject<Status, Never>? {
        didSet {
            locationStatusSubject?.send(authorizationStatus)
        }
    }
    public var isLocating: Bool = false
    public var authorizationStatus: Status {
        Status(status: locationManager.authorizationStatus)
    }

    static let shared: LocationManager = LocationManagerImpl()

    private override init() {
        self.locationManager = CLLocationManager()
        super.init()

        self.locationManager.delegate = self
        self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.pausesLocationUpdatesAutomatically = false
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func start() {
        guard authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse else {
            return
        }
        self.isLocating = true
        self.locationManager.startUpdatingLocation()
    }

    func stop() {
        self.locationManager.stopUpdatingLocation()
        self.isLocating = false
    }
}

extension LocationManagerImpl: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        guard location.horizontalAccuracy >= 0 else { return }
        if let currentLocation = self.currentLocation {
            guard currentLocation.distance(from: location) >= 100 else {
                return
            }
        }
        self.currentLocation = location
        self.locationSubject?.send(.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationStatusSubject?.send(authorizationStatus)
        switch authorizationStatus {
            case .notDetermined:
                self.locationManager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse:
                self.locationManager.requestAlwaysAuthorization()
            case .restricted, .denied: break
            case .authorizedAlways: break
            case .unknow: break
        }
    }
}
