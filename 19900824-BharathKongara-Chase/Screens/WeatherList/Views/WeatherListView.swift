//
//  WeatherDetailsView.swift
//  19900824-BharathKongara-Chase
//
//  Created by Bharath Kongara on 3/24/23.
//

import SwiftUI

public struct WeatherListView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var viewModel: WeatherListViewModel
    
    private let repository: CityRepositoryProtocol
    
    init(repository: CityRepositoryProtocol, weatherRepository: WeatherRepositoryProtocol) {
        let viewModel = WeatherListViewModel(repository: repository, weatherRepository: weatherRepository)
        _viewModel = StateObject(wrappedValue: viewModel)
        self.repository = repository
    }
    
    public var body: some View {
        NavigationView{
            VStack {
                ForEach(viewModel.allWeathers) { weather in
                    CityWeatherRow(weather: weather) { weather in
                    }
                }
                .listStyle(.plain)
                Spacer()
            }
        }
        .navigationBarTitle("Weather Search")
        .navigationBarTitleDisplayMode(.automatic)
        .sheet(isPresented: $viewModel.showingSearchView, onDismiss: {
            viewModel.refreshWeatherData()
        }, content: {
            CitySearchView(repository: repository)
        })
        .toolbar {
           ToolbarItem(placement: .primaryAction) {
              Button(action: viewModel.showSearchView) {
                 Image(systemName: "magnifyingglass")
              }
           }
        }
        .onAppear{
            viewModel.refreshWeatherData()
        }
    }
}

fileprivate
struct CityWeatherRow: View {
   let weather: Weather
   let deleteAction: (Weather) -> ()
   
   var body: some View {
      NavigationLink(destination: WeatherView(weather: weather)) {
         HStack {
            VStack(alignment: .leading, spacing: nil) {
               Text(weather.city.name + ", " + weather.city.state)
                  .lineLimit(1)
               Text(weather.city.country)
            }
            
            Spacer()
            
            HStack(alignment: .center, spacing: nil) {
               Label {
                  Text(weather.current.temp.formatted(.measurement(width: .narrow)))
               } icon: {
                  WeatherIconView(icon: weather.current.condition.icon, condition: weather.current.condition.type) { $0.font(.title3) }
               }
            }
         }
         .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
               //deleteAction(weather)
            } label: {
               Label("Delete", systemImage: "trash")
            }
         }
      }
      .padding()
      .background(
         RoundedRectangle(cornerRadius: 12, style: .continuous)
            .foregroundStyle(.thinMaterial)
      )
   }
}

struct WeatherListView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherListView(repository: MockCityRepository(), weatherRepository: MockWeatherRespository())
    }
}
