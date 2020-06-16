//
//  ElevationChart.swift
//  Workouts
//
//  Created by Emily Cheroske on 5/10/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI
import CoreLocation

struct ElevationChart: View {
    var routeData: [CLLocation]
    var body: some View {
        var data = routeData.map { return $0.altitude }
        data = data.filter { return $0 > 0 && $0 != nil }
        var netElevationGain: Double = 0
        if data.count > 0 {
            let startingElevation = data[0]
            let endingElevation = data[data.count - 1]
            netElevationGain = endingElevation - startingElevation
        }

        return VStack(alignment: .leading) {
            Text("Elevation Profile")
                .font(.headline)
                .fontWeight(.heavy)
                .padding()

            if data.count != 0 {
                Graph(rawData: data, capsuleColor: Color("V_1"), backgroundColor: Color(UIColor.systemBackground))
                HStack(alignment: .center) {
                    Text("Net elevation gain:")
                        .font(.footnote)
                        .padding(.leading, 20)
                        .foregroundColor(Color.gray)
                    Text("\(netElevationGain >= 0 ? "+" : "")\(Int(metersToFeet(meters: netElevationGain))) ft")
                        .font(.footnote)
                        .foregroundColor(netElevationGain >= 0 ? Color.green : Color.red)
                }
            } else {
                Text("No elevation data to Preview 😢")
                    .padding()
            }
        }
    }
}

struct ElevationChart_Previews: PreviewProvider {
    static var previews: some View {
        ElevationChart(routeData: [CLLocation(latitude: 0, longitude: 0)]) // TODO: come up with better preview data
    }
}
