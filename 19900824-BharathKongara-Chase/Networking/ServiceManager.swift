//
//  ServiceManager.swift
//  19900824-BharathKongara-Chase
//
//  Created by Bharath Kongara on 3/25/23.
//

import Foundation

protocol ServiceManaging {
    func fetchLocation(query: String) async throws -> [GeoCodeData]
    func fetchBoth(lat: Double, lon: Double) async throws -> (weather: WeatherData, geoCode: [GeoCodeData])
    func fetchWeather(lat: Double, lon: Double) async throws -> WeatherData
    func reverseGeoCode(lat: Double, lon: Double) async throws -> [GeoCodeData]
}

class ServiceManager: ServiceManaging {
    
   static let shared = ServiceManager()
   
   enum ServiceEndPoint {
      case weather(lat: Double, lon: Double)
      case geoCode(query: String)
      case reverseGeoCode(lat: String, lon: String)
   }
   
   private let urlSession = URLSession.shared
   
   func fetchLocation(query: String) async throws -> [GeoCodeData] {
      let geoCodeUrl = ServiceEndPoint.geoCode(query: query).url
      
      guard let (data, _) = try? await urlSession.data(from: geoCodeUrl) else {
         throw ServiceError.response
      }
      
      do {
         return try JSONDecoder().decode([GeoCodeData].self, from: data)
      } catch {
         throw ServiceError.decode
      }
   }
   
   func fetchWeather(lat: Double, lon: Double) async throws -> WeatherData {
      let weatherUrl = ServiceEndPoint.weather(lat: lat, lon: lon).url
      
      guard let (data, _) = try? await urlSession.data(from: weatherUrl) else {
         throw ServiceError.response
      }
      
      do {
         return try JSONDecoder().decode(WeatherData.self, from: data)
      } catch {
         throw ServiceError.decode
      }
   }
   
   func fetchBoth(lat: Double, lon: Double) async throws -> (weather: WeatherData, geoCode: [GeoCodeData]) {
      let geoCodeUrl = ServiceEndPoint.geoCode(query: "\(lat),\(lon)").url
      let weatherUrl = ServiceEndPoint.weather(lat: lat, lon: lon).url
      
      async let (geoCodeResponse, _) = urlSession.data(from: geoCodeUrl)
      async let (weatherResponse, _) = urlSession.data(from: weatherUrl)
      
      do {
         let geoCodeData = try await geoCodeResponse
         let weatherData = try await weatherResponse
         
         do {
            let geoCode = try JSONDecoder().decode([GeoCodeData].self, from: geoCodeData)
            let weather = try JSONDecoder().decode(WeatherData.self, from: weatherData)
            return (weather, geoCode)
         } catch {
            throw ServiceError.decode
         }
      } catch {
         throw ServiceError.response
      }
   }
    
    func reverseGeoCode(lat: Double, lon: Double) async throws -> [GeoCodeData] {
        let reverseGeoCodeUrl = ServiceEndPoint.reverseGeoCode(lat: "\(lat)", lon: "\(lon)").url
        
        guard let (data, _) = try? await urlSession.data(from: reverseGeoCodeUrl) else {
           throw ServiceError.response
        }
        
        do {
           return try JSONDecoder().decode([GeoCodeData].self, from: data)
        } catch {
           throw ServiceError.decode
        }
    }
}
