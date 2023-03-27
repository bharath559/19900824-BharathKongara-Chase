//
//  WeatherRepository.swift
//  19900824-BharathKongara-Chase
//
//  Created by Bharath Kongara on 3/25/23.
//
import Foundation
import Combine
import OSLog

protocol WeatherRepositoryProtocol {
    func fetchWeatherData(for cities: [City]) async throws -> [(weatherData: WeatherData, city: City)]
}

class WeatherRepository: WeatherRepositoryProtocol {
    
    private let serviceManager: ServiceManaging
    
    init(serviceManager: ServiceManaging) {
        self.serviceManager = serviceManager
    }
    
    func fetchWeatherData(for cities: [City]) async throws -> [(weatherData: WeatherData, city: City)] {
       return try await withThrowingTaskGroup(of: (WeatherData, City).self) { group -> [(WeatherData, City)] in
          for city in cities {
             group.addTask {
                let weatherData = try await self.serviceManager.fetchWeather(lat: city.lat, lon: city.lon)
                return (weatherData, city)
             }
          }
          
          var results = [(WeatherData, City)]()
          
          for try await value in group {
             results.append(value)
          }
          
          return results
       }
    }

}

public final class MockWeatherRespository: WeatherRepositoryProtocol {
    func fetchWeatherData(for cities: [City]) async throws -> [(weatherData: WeatherData, city: City)]  {
        return []
    }
}
