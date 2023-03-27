//
//  City.swift
//  19900824-BharathKongara-Chase
//
//  Created by Bharath Kongara on 3/25/23.
//

import Foundation

public struct City: Identifiable, Codable {
   public var id = UUID()
   let name: String
   let state: String
   let country: String
   let lat: Double
   let lon: Double
}

extension City {
    public static var mock: City {
        City(name: "", state: "", country: "", lat: 0.0, lon: 0.0)
    }
}

extension City: Equatable {
    public static func == (lhs: City, rhs: City) -> Bool {
        //TODO: this can be just check for lat and lon
        return (lhs.country == lhs.country &&  lhs.name == rhs.name &&  lhs.lat == rhs.lat && lhs.lon == lhs.lon && lhs.state == lhs.state)
    }
}
