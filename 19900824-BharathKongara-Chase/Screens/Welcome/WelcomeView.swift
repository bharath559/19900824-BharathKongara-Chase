//
//  WelcomeView.swift
//  19900824-BharathKongara-Chase
//
//  Created by Bharath Kongara on 3/23/23.
//

import SwiftUI

struct WelcomeView: View {
    private let repository: CityRepositoryProtocol
    private let weatherRepository: WeatherRepositoryProtocol
    
    init(repository: CityRepositoryProtocol, weatherRepository: WeatherRepositoryProtocol) {
        self.repository = repository
        self.weatherRepository = weatherRepository
    }
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "sun.max.fill")
                    .font(.largeTitle)
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Weather Forecast!")
                
                NavigationLink {
                    WeatherListView(repository: repository, weatherRepository: weatherRepository)
                } label: {
                    Text("Get Started")
                        .foregroundColor(.white)
                }
                .buttonStyle(.bordered)
                .background(.black)
                .tint(.black)
                .cornerRadius(10)

            }
        }
        .navigationBarHidden(true)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(repository: MockCityRepository(), weatherRepository: MockWeatherRespository())
    }
}
