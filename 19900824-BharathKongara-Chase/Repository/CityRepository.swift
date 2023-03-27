//
//  CityRepository.swift
//  19900824-BharathKongara-Chase
//
//  Created by Bharath Kongara on 3/25/23.
//

import Foundation
import Combine
import OSLog

protocol CityRepositoryProtocol {
    func saveCities(city: City)
    func getGeocodeData(searchText: String, completion: @escaping ([City]) -> Void)
    func reverseGeoCode(lat: Double, lon: Double, completion: @escaping ([City]) -> Void)
    func getCitiesFromLocalStorage() -> [City]
}

//TODO: Given time I would use reactive datastorage which emits change events on data change, that drives the UI change.
class CityRepository: CityRepositoryProtocol {
    
    let logger = Logger(subsystem: "respository", category: "")
    let kCitiesStorageKey = "cities"
    
    private let serviceManager: ServiceManaging
    
    init(serviceManager: ServiceManaging) {
        self.serviceManager = serviceManager
    }
    
    private func setupLocalStorageForCities() {
        saveCitiesToLocalStorage(cities: [City]())
    }
    
    private func saveCitiesToLocalStorage(cities: [City]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(cities)
            UserDefaults.standard.set(data, forKey: kCitiesStorageKey)

        } catch {
            logger.error("unable to store cities in local storage")
        }
    }
    
    public func getGeocodeData(searchText: String, completion: @escaping ([City]) -> Void) {
        
        Task { [self] in
            do {
               let geoCodeData = try await serviceManager.fetchLocation(query: searchText)
                await MainActor.run {
                    completion(geoCodeData.map{ City(name: $0.name, state: $0.state, country: $0.country, lat: $0.lat, lon: $0.lon)} )
                }
            } catch {
               print(error.localizedDescription)
            }
        }
           
    }
    
    public func reverseGeoCode(lat: Double, lon: Double, completion: @escaping ([City]) -> Void) {
        Task { [self] in
            do {
                let geoCodeData = try await serviceManager.reverseGeoCode(lat: lat, lon: lon)
                await MainActor.run {
                    completion(geoCodeData.map{ City(name: $0.name, state: $0.state, country: $0.country, lat: $0.lat, lon: $0.lon)} )
                }
            } catch {
               print(error.localizedDescription)
            }
        }
    }
    
    public func getCitiesFromLocalStorage() -> [City] {
        var cities: [City]?
        if let data = UserDefaults.standard.data(forKey: kCitiesStorageKey) {
            do {
                let decoder = JSONDecoder()
                cities = try decoder.decode([City].self, from: data)
            } catch {
                logger.error("unable to retrieve cities from local storage")
            }
        }
        
        return cities ?? []
    }
    
    public func saveCities(city: City) {
        
        if  UserDefaults.standard.data(forKey: kCitiesStorageKey) == nil {
            saveCitiesToLocalStorage(cities: [City]())
        }
        
        if let data = UserDefaults.standard.data(forKey: kCitiesStorageKey) {
            do {
                let decoder = JSONDecoder()
                var cities = try decoder.decode([City].self, from: data)
                guard cities.filter({ $0 == city }).count == 0 else { return }
                cities.append(city)
                saveCitiesToLocalStorage(cities: cities)
                
            } catch {
                logger.error("unable to retrieve cities from local storage")
            }
        } else {
            
        }
    }
    
}

public final class MockCityRepository: CityRepositoryProtocol {
    func reverseGeoCode(lat: Double, lon: Double, completion: @escaping ([City]) -> Void) {
        completion([])
    }
    
    func getGeocodeData(searchText: String, completion: @escaping ([City]) -> Void) {
        completion([])
    }
    
    public func saveCities(city: City) {
        //no-=op
    }
    
    public func getCitiesFromLocalStorage() -> [City] {
        return []
    }
}
