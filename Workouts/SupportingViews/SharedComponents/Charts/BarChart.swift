//
//  BarChart.swift
//  Workouts
//
//  Created by Emily Cheroske on 6/26/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct Bar: View {
    let dataItem: Int
    let unit: String
    let width: CGFloat
    let height: CGFloat
    let startColor: Color
    let endColor: Color
    
    var body: some View {
        let colors = Gradient(colors: [self.startColor, self.endColor])
        
        return VStack(alignment: .center, spacing: 0) {
            Text("\(dataItem)\(unit)")
                .font(.footnote)
                .foregroundColor(Color.gray)
                .minimumScaleFactor(0.005)
                .lineLimit(1)
                .frame(width: width - 8)

            RoundedRectangle(cornerRadius: width/4, style: .circular)
                .fill(LinearGradient(gradient: colors, startPoint: .top, endPoint: .bottom))
                .frame(width: CGFloat(width/2), height: CGFloat(height), alignment: .center)
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
        for i in 0...labels.count - 1 {
            if i % 2 == 0 {
                condensedLabels.append(labels[i])
            }
        }
        condensedLabels.append(labels[labels.count - 1])

        return HStack {
            ForEach(condensedLabels, id: \.self) { label in
                HStack {
                    Spacer()
                    VStack(alignment: .leading) {
                        Text(label)
                            .foregroundColor(Color.gray)
                            .minimumScaleFactor(0.005)
                            .lineLimit(1)
                            .frame(width: 25, height: nil, alignment: .center)
                            .font(.system(size: 10))
                            .offset(x: 0, y: -10)
                            .rotationEffect(Angle.degrees(-30))
                    }
                    
                    Spacer()
                }.padding(.top)
            }
        }
    }
}
struct XAxisGridLines: View {
    @Environment(\.colorScheme) var colorScheme

    var numLines: Int
    var xStart: Double

    var body: some View {
        let gridColor = UIColor.lightGray.withAlphaComponent(colorScheme == .dark ? 0.1 : 0.7)

        return GeometryReader { g in
            ForEach(0...self.numLines - 1, id: \.self) { i in
                VStack {
                    Path { path in
                        path.move(to: CGPoint(x: CGFloat(self.xStart) + g.size.width/CGFloat(self.numLines) * CGFloat(i), y: 0))
                        path.addLine(to: CGPoint(x: CGFloat(self.xStart) + g.size.width/CGFloat(self.numLines) * CGFloat(i), y: g.size.height))
                    }
                    .stroke(style: StrokeStyle(lineWidth: 1))
                    .foregroundColor(Color(gridColor))
                }
                .foregroundColor(Color(gridColor))
                .frame(width: g.size.width,height: 0.5)
                .padding(0)
            }
        }
    }
}
struct YAxisGridLines: View {
    @Environment(\.colorScheme) var colorScheme

    var numLines: Int
    
    // User is optionally allowed to pass in info for axis labels
    //
    var withLabels: Bool? = nil
    var maxValue: Double? = nil
    var minValue: Double? = nil
    var unit: String? = nil

    var body: some View {
        let gridColor = UIColor.lightGray.withAlphaComponent(colorScheme == .dark ? 0.3 : 0.7)
        
        let increment = ((maxValue ?? 0) - (minValue ?? 0))/Double(numLines)

        return GeometryReader { g in
            ZStack(alignment: .leading) {
            // VStack for the lines behind the bars
            //
            VStack(alignment: .center) {
                //Spacer()
                ForEach(0...self.numLines, id: \.self) { i in
                    VStack(alignment: .leading, spacing: 0) {
                        if i != 0 {
                            Spacer()
                        }
                        if i != 0 && self.withLabels != nil && self.withLabels! == true && self.unit != nil && self.minValue != nil {
                            Text("\(Int(increment * Double(self.numLines - i) + self.minValue!)) \(self.unit!)")
                                .font(.caption)
                                .fontWeight(.thin)
                                .minimumScaleFactor(0.01)
                                .padding(.leading, 5)
                                .foregroundColor(Color.gray)
                                .frame(height: g.size.height/CGFloat(2 * self.numLines))
                        }
                        VStack {
                            Path{ path in
                                path.move(to: CGPoint(x: 0, y: 0))
                                path.addLine(to: CGPoint(x: g.size.width, y: 0))
                            }
                            .stroke(style: StrokeStyle( lineWidth: 1, dash: [1]))
                            .foregroundColor(Color(gridColor))
                        }
                        .foregroundColor(Color(gridColor))
                        .frame(width: g.size.width,height: 0.5)
                        .padding(0)
                    }
                }
            }
        }
    }
    }
}
struct BarChartMidSection: View {
    let data: [Int]
    let unit: String
    let startColor: Color
    let endColor: Color
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        let max = data.max() ?? 0
        let dataRange = CGFloat(max - 0)
        let barPadding: CGFloat = 1.0
        let chartPadding: CGFloat = CGFloat(data.count) * barPadding
        

        return GeometryReader { g in
            ZStack(alignment: .bottom) {

                YAxisGridLines(numLines: 5)

                // Horizontal Stack for the Bars
                //
                HStack(alignment: .bottom, spacing: barPadding + 4) {

                    // Create the bars
                    //
                    ForEach(self.data, id: \.self) { item in
                        Bar(
                            dataItem: item,
                            unit: self.unit,
                            width: (g.size.width - chartPadding)/CGFloat(self.data.count),
                            height: ((g.size.height * 0.9) - chartPadding) * CGFloat(CGFloat(item)/dataRange),
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
    let unit: String
    let labels: [String]
    let data: [Int]
    let startColor: Color
    let endColor: Color

    var body: some View {
        return VStack(alignment: .leading) {
            Text("\(self.chartTitle)")
                .font(.headline)
                .fontWeight(.light)
                .padding([.leading])
                .offset(x: 0, y: 10)
            BarChartMidSection(data: data, unit: unit, startColor: self.startColor, endColor: self.endColor)
            XAxis(labels: labels)
                .padding(.leading, 20)
                .padding(.trailing, 20)
        }
    }
}

struct BarChart_Previews: PreviewProvider {
    static var previews: some View {
        BarChart(
            chartTitle: "Bar chart in SwiftUI",
            unit: "hi",
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
