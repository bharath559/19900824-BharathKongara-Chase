//
//  WeatherData.swift
//  19900824-BharathKongara-Chase
//
//  Created by Bharath Kongara on 3/25/23.
//

import Foundation

struct WeatherData: Decodable {
   let current: Current
   let daily: [Day]
   let hourly: [Hour]
   let lat: Double
   let lon: Double
   let timeZone: String
   let timeZoneOffset: Int
   
   enum CodingKeys: String, CodingKey {
      case current, daily, hourly
      case lat, lon
      case timeZone = "timezone"
      case timeZoneOffset = "timezone_offset"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      current = try container.decode(Current.self, forKey: .current)
      daily = try container.decode([Day].self, forKey: .daily)
      hourly = try container.decode([Hour].self, forKey: .hourly)
      lat = try container.decode(Double.self, forKey: .lat)
      lon = try container.decode(Double.self, forKey: .lon)
      timeZone = try container.decode(String.self, forKey: .timeZone)
      timeZoneOffset = try container.decode(Int.self, forKey: .timeZoneOffset)
   }
}


// MARK: - Current

extension WeatherData {
   struct Current: Decodable {
      let dateTime: Date
      let humidity: Double
      let sunrise: Date
      let sunset: Date
      let temp: Double
      let uvi: Double
      let conditions: [Condition]
      let windSpeed: Double
      
      enum CodingKeys: String, CodingKey {
         case dateTime = "dt"
         case humidity, sunrise, sunset, temp, uvi
         case conditions = "weather"
         case windSpeed = "wind_speed"
      }
      
      init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         dateTime = Date(timeIntervalSince1970: try container.decode(Double.self, forKey: .dateTime))
         humidity = try container.decode(Double.self, forKey: .humidity) / 100.0
         sunrise = Date(timeIntervalSince1970: try container.decode(Double.self, forKey: .sunrise))
         sunset = Date(timeIntervalSince1970: try container.decode(Double.self, forKey: .sunset))
         temp = try container.decode(Double.self, forKey: .temp)
         uvi = try container.decode(Double.self, forKey: .uvi)
         conditions = try container.decode([Condition].self, forKey: .conditions)
         windSpeed = try container.decode(Double.self, forKey: .windSpeed)
      }
   }
}


// MARK: - Day

extension WeatherData {
   struct Day: Decodable {
      let day: Date
      let humidity: Double
      let precipitationChance: Double
      let sunrise: Date
      let sunset: Date
      let maxTemp: Double
      let minTemp: Double
      let uvi: Double
      let conditions: [Condition]
      let windSpeed: Double
      let rain: Double
      let snow: Double
      
      enum CodingKeys: String, CodingKey {
         case day = "dt"
         case humidity
         case precipitationChance = "pop"
         case sunrise, sunset, temp, uvi
         case conditions = "weather"
         case windSpeed = "wind_speed"
         case rain, snow
      }
      
      enum TemperatureKeys: String, CodingKey {
         case day, eve, max, min, morn, night
      }
      
      init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         let temperatureContainer = try container.nestedContainer(keyedBy: TemperatureKeys.self, forKey: .temp)
         day = Date(timeIntervalSince1970: TimeInterval(try container.decode(Int.self, forKey: .day)))
         humidity = try container.decode(Double.self, forKey: .humidity) / 100.0
         precipitationChance = try container.decode(Double.self, forKey: .precipitationChance)
         sunrise = Date(timeIntervalSince1970: try container.decode(Double.self, forKey: .sunrise))
         sunset = Date(timeIntervalSince1970: try container.decode(Double.self, forKey: .sunset))
         uvi = try container.decode(Double.self, forKey: .uvi)
         conditions = try container.decode([Condition].self, forKey: .conditions)
         windSpeed = try container.decode(Double.self, forKey: .windSpeed)
         maxTemp = try temperatureContainer.decode(Double.self, forKey: .max)
         minTemp = try temperatureContainer.decode(Double.self, forKey: .min)
         rain = try container.decodeIfPresent(Double.self, forKey: .rain) ?? 0
         snow = try container.decodeIfPresent(Double.self, forKey: .snow) ?? 0
      }
   }
}


// MARK: - Hour

extension WeatherData {
   struct Hour: Decodable {
      let hour: Date
      let humidity: Double
      let precipitationChance: Double
      let temp: Double
      let uvi: Double
      let conditions: [Condition]
      let windSpeed: Double
      
      enum CodingKeys: String, CodingKey {
         case hour = "dt"
         case humidity
         case precipitationChance = "pop"
         case temp, uvi
         case conditions = "weather"
         case windSpeed = "wind_speed"
      }
      
      init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         hour = Date(timeIntervalSince1970: TimeInterval(try container.decode(Int.self, forKey: .hour)))
         humidity = try container.decode(Double.self, forKey: .humidity) / 100.0
         precipitationChance = try container.decode(Double.self, forKey: .precipitationChance)
         temp = try container.decode(Double.self, forKey: .temp)
         uvi = try container.decode(Double.self, forKey: .uvi)
         conditions = try container.decode([Condition].self, forKey: .conditions)
         windSpeed = try container.decode(Double.self, forKey: .windSpeed)
      }
   }
}



// MARK: - Condition

extension WeatherData {
   struct Condition: Decodable {
      let code: Int
      let main: String
      let detail: String
      
      static let `default` = Condition(code: 0, main: "", detail: "")
      
      enum CodingKeys: String, CodingKey {
         case code = "id"
         case main
         case detail = "description"
      }
      
      init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         code = try container.decode(Int.self, forKey: .code)
         main = try container.decode(String.self, forKey: .main)
         detail = try container.decode(String.self, forKey: .detail)
      }
      
      private init(code: Int, main: String, detail: String) {
         self.code = code
         self.main = main
         self.detail = detail
      }
   }
}
