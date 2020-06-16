//
//  HeartRateChart.swift
//  Workouts
//
//  Created by Emily Cheroske on 5/10/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct HeartRateChart: View {
    var heartRateData: [Double]

    var body: some View {
        let sumArray = heartRateData.reduce(0, +)
        let average = heartRateData.count > 0 ? Int(sumArray/Double(heartRateData.count)) : 0

        return VStack(alignment: .leading) {
            Text("Heart Rate")
                .font(.headline)
                .fontWeight(.heavy)
                .padding()

            if heartRateData.count > 0 {
                Graph(rawData: heartRateData, capsuleColor: Color("AN_1"))
                Text("Average HR: \(average) ❤️")
                    .font(.footnote)
                    .padding(.leading, 20)
                    .foregroundColor(Color.gray)
            } else {
                Text("No data available. 😢")
                    .padding()
            }
        }
    }
}

struct HeartRateChart_Previews: PreviewProvider {
    static var previews: some View {
        HeartRateChart(heartRateData: [66,67,70,77,80,77,65,63,62,60])
    }
}
