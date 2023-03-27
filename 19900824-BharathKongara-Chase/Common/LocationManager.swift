//
//  LocationManager.swift
//  19900824-BharathKongara-Chase
//
//  Created by Bharath Kongara on 3/24/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var isLoading = false
    @Published var currentLocationStatus: CLAuthorizationStatus
    
    override init() {
        self.currentLocationStatus = manager.authorizationStatus
        super.init()
        manager.delegate = self
        requestLocation()
    }
    
    func requestLocation() {
        isLoading = true
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        isLoading = false
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location", error)
        isLoading = false
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        currentLocationStatus = manager.authorizationStatus
            switch manager.authorizationStatus {
            case .authorizedWhenInUse:
                
                manager.requestLocation()
                break
                
            case .restricted, .denied:
                break
                
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
                break
                
            default:
                break
            }
        }
    
}

