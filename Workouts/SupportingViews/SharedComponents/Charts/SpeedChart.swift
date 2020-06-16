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
        let sumArray = data.reduce(0, +)
        let average = sumArray/Double(data.count)
        
        let minPerMilePace = metersPerSecondToMinPerMile(pace: average)
        let minValue = Int(minPerMilePace)
        let secondsValue = Int(60 * minPerMilePace.truncatingRemainder(dividingBy: 1))

        return VStack(alignment: .leading) {
            Text("Workout Pace")
                .font(.headline)
                .fontWeight(.heavy)
                .padding()

            if data.count > 0 {
                Graph(rawData: data, capsuleColor: Color("K_1"))
                HStack {
                    Text("Average Pace: \(minValue)'\(secondsValue)'' /mi")
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
