//
//  BarChart.swift
//  Workouts
//
//  Created by Emily Cheroske on 6/26/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct Bar: View {
    let width: CGFloat
    let height: CGFloat
    let startColor: Color
    let endColor: Color
    
    var body: some View {
        let colors = Gradient(colors: [self.startColor, self.endColor])
        
        return VStack(alignment: .center, spacing: 0) {
            Text("\(Int(height))")
                .font(.caption)
                .foregroundColor(Color.gray)
                .fixedSize()
                .frame(width: width)

            RoundedRectangle(cornerRadius: width/2, style: .circular)
                .fill(LinearGradient(gradient: colors, startPoint: .top, endPoint: .bottom))
                .frame(width: CGFloat(width), height: CGFloat(height))
                .foregroundColor(.pink)
        }
    }
}
struct XAxis: View {
    var labels: [String]

    var body: some View {
        var condensedLabels = [String]()
        
        // If we have more than 4 labels, we should grab every xth
        // label so that we are only every displaying a max of 4 labels
        // on the x-axis because we have minimal screen space and we don't
        // want to shrink the text beyond recognition with larger datasets
        //
        if labels.count > 4 {
            let incrementAmount = Int(labels.count/4)
            for i in 0...3 {
                condensedLabels.append(labels[i*incrementAmount])
            }
        } else {
            condensedLabels = labels
        }
        return HStack {
            ForEach(condensedLabels, id: \.self) { label in
                HStack {
                    Spacer()
                    VStack(alignment: .leading) {
                        Text(label)
                            .foregroundColor(Color.gray)
                            .font(.system(size: 10))
                    }
                    
                    Spacer()
                }.padding(.top)
            }
        }
    }
}
struct BarChartMidSection: View {
    let data: [Int]
    let startColor: Color
    let endColor: Color

    var body: some View {
        let max = data.max() ?? 0
        let dataRange = CGFloat(max - (data.min() ?? 0))
        let barPadding: CGFloat = 1.0
        let chartPadding: CGFloat = CGFloat(data.count) * barPadding

        return GeometryReader { g in
            ZStack(alignment: .bottom) {
                // VStack for the lines behind the bars
                //
                VStack(alignment: .center) {
                    //Spacer()
                    ForEach(0...5, id: \.self) { i in
                        VStack {
                            if i != 0 {
                                Spacer()
                            }
                            Rectangle()
                                .size(width: g.size.width, height: 0.5)
                                .foregroundColor(.gray)
                                 .frame(height: 0.5)
                                .padding(0)
                        }
                    }
                }

                // Horizontal Stack for the Bars
                //
                HStack(alignment: .bottom, spacing: barPadding) {

                    // Create the bars
                    //
                    ForEach(self.data, id: \.self) { item in
                        Bar(
                            width: (g.size.width - chartPadding - 40)/CGFloat(self.data.count),
                            height: ((g.size.height * 0.7) - chartPadding) * CGFloat(CGFloat(item)/dataRange),
                            startColor: self.startColor,
                            endColor: self.endColor
                        )
                    }
                }
            }
        }
    }
}

struct BarChart: View {
    let chartTitle: String
    let labels: [String]
    let data: [Int]
    let startColor: Color
    let endColor: Color

    var body: some View {
        return VStack(alignment: .leading) {
            Text("\(self.chartTitle)")
                .font(.headline)
                .fontWeight(.heavy)
            BarChartMidSection(data: data, startColor: self.startColor, endColor: self.endColor)
            XAxis(labels: labels)
        }
    }
}

struct BarChart_Previews: PreviewProvider {
    static var previews: some View {
        BarChart(
            chartTitle: "Bar chart in SwiftUI",
            labels: [
                "Sat", "Sun", "Mon", "Tues", "Thu", "Fri", "Sat", "Sat", "Sun", "Mon", "Tues", "Thu", "Fri", "Sat"
            ],
            data: [
                10, 80, 40, 20, 80, 60, 30, 10, 80, 40, 20, 80, 60, 30
            ],
            startColor: .blue,
            endColor: .purple
            ).frame(height: 450).padding()
    }
}
