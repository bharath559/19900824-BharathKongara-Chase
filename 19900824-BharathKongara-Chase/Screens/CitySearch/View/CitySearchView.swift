//
//  CitySearchView.swift
//  19900824-BharathKongara-Chase
//
//  Created by Bharath Kongara on 3/25/23.
//

import SwiftUI

struct CitySearchView: View {
   @Environment(\.dismissSearch) private var dismissSearch
   @Environment(\.dismiss) private var dismiss
   @StateObject private var viewModel: CitySearchViewModel
   
    init(repository: CityRepositoryProtocol) {
       let locationSearchViewModel = CitySearchViewModel(repository: repository)
      _viewModel = StateObject(wrappedValue: locationSearchViewModel)
   }
   
   var body: some View {
      NavigationView {
         ZStack {
            
            ScrollView {
                ForEach(viewModel.cityList) { city in
                  Button {
                      viewModel.saveCity(city: city)
                      dismiss()
                  } label: {
                      CitySearchRow(city: city)
                  }
                  .foregroundColor(.primary)
                  .padding(.horizontal)
               }
            }
         }
         .navigationBarTitleDisplayMode(.inline)
      }
      .searchable(
         text: $viewModel.searchText,
         placement: .navigationBarDrawer(displayMode: .always),
         prompt: nil
      )
      .onChange(of: viewModel.searchText, perform: { _ in
          viewModel.getGeoCodeData {
             dismissSearch()
          }
      })
      
   }
}

fileprivate
struct CitySearchRow: View {
   let city: City
   
   var body: some View {
      VStack(alignment: .leading, spacing: nil) {
         Group {
            if city.state.isEmpty {
               Text("\(city.name)")
                  .bold()
            } else {
               Text("\(city.name), \(city.state)")
                  .bold()
                  .lineLimit(1)
            }
         }
         .font(.system(.title3, design: .rounded))
         Text(city.country)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(15)
      .background(
         RoundedRectangle(cornerRadius: 12, style: .continuous)
            .foregroundStyle(.thinMaterial)
      )
   }
}


struct CitySearchView_Previews: PreviewProvider {
   static var previews: some View {
       CitySearchView(repository: MockCityRepository())
   }
}
