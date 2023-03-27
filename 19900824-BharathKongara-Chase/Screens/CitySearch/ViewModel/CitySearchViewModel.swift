//
//  CitySearchViewModel.swift
//  19900824-BharathKongara-Chase
//
//  Created by Bharath Kongara on 3/25/23.
//

import Foundation

import Combine
import SwiftUI

class CitySearchViewModel: ObservableObject {
   @Published private (set) var cityList: [City] = []
   @Published var searchText: String = ""
   
    private let repository: CityRepositoryProtocol
    private let locationManager = LocationManager()
   
   init(repository: CityRepositoryProtocol) {
       self.repository = repository
   }
    
    func saveCity(city: City) {
        repository.saveCities(city: city)
    }
  
   func getGeoCodeData(completion: @escaping () -> Void) {
      guard !self.searchText.isEmpty else {
          cityList.removeAll()
         completion()
         return
      }
       
      repository.getGeocodeData(searchText: self.searchText, completion: { citiesResponse in
           self.cityList = citiesResponse
           completion()
      })
    
   }
}
