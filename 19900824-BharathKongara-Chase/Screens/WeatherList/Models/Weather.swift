//
//  Weather.swift
//  19900824-BharathKongara-Chase
//
//  Created by Bharath Kongara on 3/25/23.
//

import Foundation
import SwiftUI

struct Weather: Identifiable {
   var id = UUID()
   let city: City
   let current: CurrentWeather
   let daily: [DayWeather]
   let hourly: [HourWeather]
   let timeZone: TimeZone
   
   init(city: City, current: CurrentWeather, daily: [DayWeather], hourly: [HourWeather], timeZone: TimeZone) {
      self.city = city
      self.current = current
      self.daily = daily.sorted(by: { $0.day < $1.day })
      self.hourly = hourly.sorted(by: { $0.hour < $1.hour })
      self.timeZone = timeZone
   }
}

extension Weather {
    public static var mock: Weather {
        Weather(city: City.mock, current: CurrentWeather.mock, daily: [], hourly: [], timeZone: .current)
    }
}


extension WeatherData.Current {
    func toDomainModel() -> CurrentWeather {
        CurrentWeather(dateTime: dateTime,
                       humidity: humidity,
                       sunrise: sunrise,
                       sunset: sunset,
                       temp: Measurement(value: temp, unit: .fahrenheit),
                       uvi: uvi,
                       condition: conditions.primary.toDomainModel(sunrise: sunrise, sunSet: sunset, currentTime: dateTime),
                       windSpeed: Measurement(value: windSpeed, unit: .milesPerHour))
    }
}

extension WeatherData.Condition {
    func toDomainModel(sunrise: Date, sunSet: Date, currentTime: Date) -> WeatherCondition {
        let isDay = currentTime > sunrise && currentTime < sunSet
        return WeatherCondition(code: code, main: main, detail: detail, isDay: isDay)
    }
}

extension WeatherData.Day {
    func toDomainModel(currentTime: Date) -> DayWeather {
        DayWeather(day: day,
                  humidity: humidity,
                  precipitationChance: precipitationChance,
                  sunrise: sunrise,
                  sunset: sunset,
                  tempMax: Measurement(value: maxTemp, unit: .fahrenheit),
                  tempMin: Measurement(value: minTemp, unit: .fahrenheit),
                  uvi: uvi,
                   condition: conditions.primary.toDomainModel(sunrise: sunrise, sunSet: sunset, currentTime: currentTime),
                  windSpeed: Measurement(value: windSpeed, unit: .milesPerHour),
                  rain: Measurement(value: rain, unit: .milliliters),
                  snow: Measurement(value: snow, unit: .milliliters))
    }
}

extension WeatherData.Hour {
    
    func toDomainModel() -> HourWeather {
        HourWeather(
                    hour: hour,
                    humidity: humidity,
                    precipitationChance: precipitationChance,
                    temp: Measurement(value: temp, unit: .fahrenheit),
                    uvi: uvi,
                    condition: conditions.primary,
                    windSpeed: Measurement(value: windSpeed, unit: .milesPerHour))
    }
    
}


// MARK: - CurrentWeather
struct CurrentWeather {
  let dateTime: Date
  let humidity: Double
  let sunrise: Date
  let sunset: Date
  let temp: Measurement<UnitTemperature>
  let uvi: Double
  let condition: WeatherCondition
  let windSpeed: Measurement<UnitSpeed>
  
  var isDay: Bool {
     dateTime > sunrise && dateTime < sunset
  }
}


extension CurrentWeather {
    public static var mock: CurrentWeather  {
        CurrentWeather(
                       dateTime: Date(),
                               humidity: 0.0,
                       sunrise: Date(),
                       sunset: Date(),
                       temp: Measurement(value: 30, unit: .fahrenheit),
                       uvi: 80,
                       condition: WeatherCondition.default,
                       windSpeed: Measurement(value: 0.0, unit: .milesPerHour))
    }
}


// MARK: - DayWeather
struct DayWeather: Identifiable {
  var id: Date { day }
  let day: Date
  let humidity: Double
  let precipitationChance: Double
  let sunrise: Date
  let sunset: Date
  let tempMax: Measurement<UnitTemperature>
  let tempMin: Measurement<UnitTemperature>
  let uvi: Double
  let condition: WeatherCondition
  let windSpeed: Measurement<UnitSpeed>
  let rain: Measurement<UnitVolume>
  let snow: Measurement<UnitVolume>
}





// MARK: - HourWeather
struct HourWeather: Identifiable {
   var id: Date { hour }
   let hour: Date
   let humidity: Double
   let precipitationChance: Double
   let temp: Measurement<UnitTemperature>
   let uvi: Double
   let condition: WeatherData.Condition
   let windSpeed: Measurement<UnitSpeed>
}

   

struct WeatherCondition {
  static let `default` = WeatherCondition(code: 0, main: "", detail: "", isDay: true)
  
  let code: Int
  let main: String
  let detail: String
  let type: WeatherConditionType
   let isDay: Bool
  
  var icon: Image {
     Image(systemName: type.getIconName(isDayTime: isDay))
  }
  
   public init(code: Int, main: String, detail: String, isDay: Bool) {
     self.isDay = isDay
     self.code = code
     self.main = main
     self.detail = detail
     self.type = WeatherConditionType.allCases.first(where: { $0.rawValue == code }) ?? .default
  }
}



extension Array where Element == WeatherData.Condition {
   var primary: WeatherData.Condition {
       guard let first = self.first else {
         return WeatherData.Condition.default
      }
      return first
   }
}
