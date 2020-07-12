//
//  SpeedChart.swift
//  Workouts
//
//  Created by Emily Cheroske on 5/10/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI
import CoreLocation

struct SpeedChart: View {
    var routeData: [CLLocation]
    
    var body: some View {
        var data = routeData.map { return $0.speed }
        data = data.filter { return $0 > 0 && $0 != nil }
        let averageSpeed = getAverageSpeed(segment: routeData)
        let mphValue = metersPerSecondToMPH(pace: averageSpeed)

        return VStack(alignment: .leading) {
            Text("Workout Pace")
                .font(.headline)
                .fontWeight(.heavy)
                .padding()

            if data.count > 0 {
                Graph(rawData: data, capsuleColor: Color("K_1"))
                HStack {
                    Text("Average Pace: \(getPaceString(route: routeData)) - \(String(format: "%.1f", mphValue)) mph")
                        .font(.footnote)
                        .padding(.leading, 20)
                        .foregroundColor(Color.gray)
                }
            } else {
                Text("No data on speed is available. 😢")
                    .padding()
            }
        }
    }
}

struct SpeedChart_Previews: PreviewProvider {
    static var previews: some View {
        SpeedChart(routeData: [CLLocation(latitude: 0, longitude: 0)])
    }
}
