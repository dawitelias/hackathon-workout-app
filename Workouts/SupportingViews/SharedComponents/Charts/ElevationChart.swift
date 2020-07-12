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
        let netElevationGain = getElevation(format: .net, segment: routeData)
        let totalGain = getElevation(format: .gain, segment: routeData)
        let totalLoss = getElevation(format: .loss, segment: routeData)

        return VStack(alignment: .leading) {
            Text("Elevation Profile")
                .font(.headline)
                .fontWeight(.heavy)
                .padding()

            if data.count != 0 {
                Graph(rawData: data, capsuleColor: Color("V_1"), backgroundColor: Color(UIColor.systemBackground))
                HStack(alignment: .center) {
                    Text("Net Elevation Gain:")
                        .font(.footnote)
                        .padding(.leading, 20)
                        .foregroundColor(Color.gray)
                    Text("\(Int(netElevationGain))ft")
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                    Text("(+ \(Int(totalGain))ft")
                        .font(.footnote)
                        .foregroundColor(.green)
                    Text("\(Int(totalLoss))ft)")
                        .font(.footnote)
                        .foregroundColor(.red)
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
