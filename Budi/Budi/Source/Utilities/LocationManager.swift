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

    func searchAddress(_ searchText: String, _ completion: @escaping ([String]) -> Void) {
        let result = Location().location.filter { $0.contains(searchText) }
        completion(result)
    }

    func getAddress(_ completion: @escaping (Result<String, Error>) -> Void) {
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
            if let coordinate = manager.location?.coordinate {
                let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                let locale = Locale(identifier: "Ko-kr")
                CLGeocoder().reverseGeocodeLocation(location, preferredLocale: locale) { placemarks, error in
                    guard let placemark = placemarks?.first, let administrativeArea = placemark.administrativeArea, let locality = placemark.locality else { return }

                    let address = "\(administrativeArea) \(locality == "세종특별자치시" ? "" : locality)"
                    completion(.success(address))

                    if let error = error {
                        completion(.failure(error))
                    }
                }
            }
        } else {
            requestWhenInUseAuthorization()
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways: NotificationCenter.default.post(name: NSNotification.Name(rawValue: "locationAuthorizationSuccess"), object: nil)
        case .authorizedWhenInUse: NotificationCenter.default.post(name: NSNotification.Name(rawValue: "locationAuthorizationSuccess"), object: nil)
        case .notDetermined: break
        case .restricted, .denied: break
        default: break
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
