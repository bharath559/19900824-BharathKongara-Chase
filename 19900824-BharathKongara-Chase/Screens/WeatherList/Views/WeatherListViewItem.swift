//
//  WeatherListViewItem.swift
//  19900824-BharathKongara-Chase
//
//  Created by Bharath Kongara on 3/24/23.
//

import SwiftUI

struct WeatherListViewItem: View {
    var body: some View {
        HStack{
            VStack {
                Text("Albany, New York")
                Text("United States")
            }
            
            Spacer()
            HStack {
                Image(systemName: "sun.max.fill")
                    .font(.largeTitle)
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("41")
            }
            
        }
        
    }
}

struct WeatherListViewItem_Previews: PreviewProvider {
    static var previews: some View {
        WeatherListViewItem()
    }
}
