//
//  ServiceEndpoint.swift
//  19900824-BharathKongara-Chase
//
//  Created by Bharath Kongara on 3/26/23.
//

import Foundation

extension ServiceManager.ServiceEndPoint {
   private static let apiKey = "9b36b4c429040e2d40ee62be45bcdb82"
   
   var url: URL {
      var urlComponents = URLComponents(string: baseUrl)
      urlComponents?.path = path
      urlComponents?.queryItems = queryItems
      
      guard let url = urlComponents?.url else {
         fatalError("Invalid URL")
      }
      
      return url
   }
   
   var baseUrl: String {
       return "https://api.openweathermap.org"
   }
   
   var path: String {
      switch self {
         case .weather:
            return "/data/3.0/onecall"
         case .geoCode:
            return "/geo/1.0/direct"
      case .reverseGeoCode(lat: _, lon: _):
            return "/geo/1.0/reverse"
          
      }
   }
   
   var queryItems: [URLQueryItem]? {
      switch self {
         case .weather(let lat, let lon):
            return [
               URLQueryItem(name: "lat", value: "\(lat)"),
               URLQueryItem(name: "lon", value: "\(lon)"),
               URLQueryItem(name: "exclude", value: "minutely"),
               URLQueryItem(name: "units", value: "imperial"),
               URLQueryItem(name: "appid", value: Self.apiKey),
            ]
         case .geoCode(let query):
            return [
               URLQueryItem(name: "q", value: query),
               URLQueryItem(name: "appid", value: Self.apiKey)
            ]
      case .reverseGeoCode(lat: let lat, lon: let lon):
          return [
                URLQueryItem(name: "lat", value: "\(lat)"),
                URLQueryItem(name: "lon", value: "\(lon)"),
                URLQueryItem(name: "appid", value: Self.apiKey)
          ]
      }
   }
}
