//
//  WeatherIconView.swift
//  19900824-BharathKongara-Chase
//
//  Created by Bharath Kongara on 3/24/23.
//

import SwiftUI

struct WeatherIconView<Content: View>: View {
   private let condition: WeatherConditionType
   private let icon: Image
   private let content: (Image) -> Content
   
   init(icon: Image, condition: WeatherConditionType, content: @escaping (Image) -> Content) {
      self.icon = icon
      self.condition = condition
      self.content = content
   }
   
   var body: some View {
      content(icon)
         .symbolRenderingMode(.palette)
         .weatherIconStyle(condition: condition)
   }
}

struct WeatherIconView_Previews: PreviewProvider {
   static let conditionType = WeatherConditionType.clear
   static var icon: Image {
      Image(systemName: conditionType.getIconName(isDayTime: true))
   }
   
   static var previews: some View {
      WeatherIconView(icon: icon, condition: conditionType) { image in
         image.resizable().scaledToFit()
      }
      .previewLayout(.sizeThatFits)
   }
}
