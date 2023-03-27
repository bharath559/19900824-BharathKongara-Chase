//
//  WeatherListViewModel.swift
//  19900824-BharathKongara-Chase
//
//  Created by Bharath Kongara on 3/25/23.
//

import Combine
import Foundation

public class WeatherListViewModel: ObservableObject {
   
   @Published var allWeathers = [Weather]()
   @Published var showingSearchView: Bool = false
   private let locationManager = LocationManager()
   private var locationSubscriber: AnyCancellable?
   
   private let repository: CityRepositoryProtocol
   private let weatherRepository: WeatherRepositoryProtocol
    
    init(repository: CityRepositoryProtocol, weatherRepository: WeatherRepositoryProtocol) {
        self.repository = repository
        self.weatherRepository = weatherRepository
        refreshWeatherData()
        setupLocationSubscriber()
   }
   
   func showSearchView() {
      showingSearchView = true
   }
   
    func setupLocationSubscriber() {
        locationSubscriber = locationManager.$location.sink { [weak self] coordinates in
            guard let self, let coordinates = coordinates else { return }
            self.reverseGeoCode(lat: coordinates.latitude, lon: coordinates.longitude)
         }
    }
    
    func reverseGeoCode(lat: Double, lon: Double) {
        repository.reverseGeoCode(lat: lat, lon: lon) { [weak self]  citiesResponse in
            guard let self  = self else { return }
            self.repository.saveCities(city: citiesResponse[0])
            self.refreshWeatherData()
        }
    }
   
    func refreshWeatherData() {
        let cities = repository.getCitiesFromLocalStorage()
        guard cities.count > 0 else { return }
        Task {
            do {
                let allData = try await  weatherRepository.fetchWeatherData(for: cities)
                await MainActor.run {
                    self.allWeathers = convertWeatherToDisplayableData(allData: allData)
                }
            } catch {
                print("weather data fetch failed")
            }
        }
        
        
    }
    
    
    func convertWeatherToDisplayableData(allData: [(weatherData: WeatherData, city: City)]) -> [Weather] {
        
        return allData
            .map { (weatherData, city) in
                let currentWeather = weatherData.current.toDomainModel()
                let dailyWeather = weatherData.daily.map { $0.toDomainModel(currentTime: currentWeather.dateTime) }
                let hourlyWeather = weatherData.hourly.map{ $0.toDomainModel() }
                
                let timeOffset = Int64(weatherData.timeZoneOffset)
                
                return Weather(city: city, current: currentWeather, daily: dailyWeather, hourly: hourlyWeather, timeZone: TimeZone(secondsFromGMT: Int(timeOffset)) ?? .autoupdatingCurrent)
            }
    }
}
