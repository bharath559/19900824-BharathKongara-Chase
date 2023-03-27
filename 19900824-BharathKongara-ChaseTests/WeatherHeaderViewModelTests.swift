//
//  WeatherHeaderViewModelTests.swift
//  19900824-BharathKongara-ChaseTests
//
//  Created by Bharath Kongara on 3/26/23.
//

import XCTest
@testable import _9900824_BharathKongara_Chase

final class WeatherHeaderViewModelTests: XCTestCase {
    
    var testObject: WeatherHeaderViewModel!
    
    override func setUp() {
        let city = City(name: "testCity", state: "testState", country: "testCountry", lat: 10.0, lon: 11.0)
        let currentWeather = CurrentWeather(dateTime: .now,
                                            humidity: 10.0,
                                            sunrise: .now.adding(hours: 2),
                                            sunset: .now.adding(hours: 10),
                                            temp: Measurement(value: 70.0, unit: .fahrenheit),
                                                                               uvi: 10.0,
                                            condition: WeatherCondition(code: 3, main: "", detail: "", isDay: true),
                                            windSpeed: Measurement(value: 10, unit: .milesPerHour))
        let weather = Weather(city: city, current: currentWeather, daily: [], hourly: [], timeZone: .current)
        testObject = WeatherHeaderViewModel(weather: weather)
    }

    override func setUpWithError() throws {
       
    }

    override func tearDownWithError() throws {
      
    }
    
    func testViewData() {
        XCTAssertEqual(testObject.locationName, "testCity, testState")
        XCTAssertEqual(testObject.temp, "70°")
        XCTAssertFalse(testObject.willRain)
        XCTAssertEqual(testObject.windSpeed, "10 mph")
        XCTAssertEqual(testObject.humidity, "1,000%")
    }

}

extension Date {
    func adding(hours: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: hours, to: self)!
    }
}
