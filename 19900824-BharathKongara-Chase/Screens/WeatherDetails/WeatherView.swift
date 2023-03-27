//
//  WeatherView.swift
//  19900824-BharathKongara-Chase
//
//  Created by Bharath Kongara on 3/25/23.
//

import SwiftUI

struct WeatherView: View {
   private var sectionSpacing: CGFloat = 40
   private let weather: Weather
   
   init(weather: Weather) {
      self.weather = weather
   }
   
   var body: some View {
      ZStack {
         ScrollView(.vertical, showsIndicators: false) {
             Text(weather.city.name).font(.largeTitle)
            VStack(alignment: .center, spacing: sectionSpacing) {
               WeatherHeaderView(weather: weather)
               WeatherDailyView(weather: weather)
            }
            .padding(.top)
            .padding(.horizontal)
         }
      }
      .navigationBarHidden(true)
      .navigationBarTitleDisplayMode(.large)
   }
}

struct WeatherView_Previews: PreviewProvider {
   static var previews: some View {
      NavigationView {
         VStack {
             WeatherView(weather: Weather.mock)
         }
      }
   }
}
