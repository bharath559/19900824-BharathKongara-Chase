//
//  LocationData.swift
//  19900824-BharathKongara-Chase
//
//  Created by Bharath Kongara on 3/25/23.
//

import Foundation

struct GeoCodeData: Decodable {
   let name: String
   let state: String
   let country: String
   let lat: Double
   let lon: Double
}
