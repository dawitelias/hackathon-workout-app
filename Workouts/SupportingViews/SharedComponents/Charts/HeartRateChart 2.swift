//
//  HeartRateChart.swift
//  Workouts
//
//  Created by Emily Cheroske on 5/10/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct HeartRateChart: View {
    var heartRateData: [HeartRateReading]

    var body: some View {
        let heartRateValues = heartRateData.map { return Double($0.reading) }
        let sumArray = heartRateValues.reduce(0, +)
        let average = heartRateValues.count > 0 ? Int(Double(sumArray)/Double(heartRateValues.count)) : 0

        return VStack(alignment: .leading) {
            if heartRateData.count > 0 {
                CapsuleGraph(data: heartRateValues, showAxisLabels: true, capsuleColor: Color("AN_1"), units: "bpm")
                // XAxis Grid Lines
                //
                // XAxisGridLines(numLines: 4, xStart: Double(self.chartPadding - 10))
                HStack {
                    Text("test")
                    Spacer()
                    Text("test")
                    Spacer()
                    Text("test")
                }.padding([.leading, .trailing], 10)

                Spacer()

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
        HeartRateChart(heartRateData: [
            HeartRateReading(20, Date())
        ])
    }
}
