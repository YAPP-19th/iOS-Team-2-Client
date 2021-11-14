//
//  LocationManager.swift
//  Budi
//
//  Created by leeesangheee on 2021/11/14.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    private var manager: CLLocationManager = CLLocationManager()

    private override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }

    func getAdministrativeArea(_ completion: @escaping (Result<String, Error>) -> Void) {
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
            if let coordinate = manager.location?.coordinate {
                let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                let locale = Locale(identifier: "Ko-kr")
                CLGeocoder().reverseGeocodeLocation(location, preferredLocale: locale) { placemarks, error in
                    if let administrativeArea: String = placemarks?.first?.administrativeArea {
                        completion(.success(administrativeArea))
                    }
                    if let error = error {
                        completion(.failure(error))
                    }
                }
            }
        } else {
            requestWhenInUseAuthorization()
        }
    }

    func requestWhenInUseAuthorization() {
        switch manager.authorizationStatus {
        case .authorizedAlways: break
        case .authorizedWhenInUse: break
        case .notDetermined: manager.requestWhenInUseAuthorization()
        case .restricted, .denied: manager.requestWhenInUseAuthorization()
        default: break
        }
    }
}
