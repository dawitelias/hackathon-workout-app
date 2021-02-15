//
//  BarChart.swift
//  Workouts
//
//  Created by Emily Cheroske on 6/26/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//
import SwiftUI

@ViewBuilder
func bar(height: CGFloat, width: CGFloat) -> some View {
    Capsule(style: .continuous)
        .frame(width: CGFloat(width/2), height: CGFloat(height), alignment: .center)
        .foregroundColor(Color(UIColor.secondaryLabel))
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
                            .foregroundColor(Color(UIColor.systemGray))
                            //.minimumScaleFactor(0.005)
                            .lineLimit(1)
                            .fixedSize()
                            .font(.system(size: 10))
                            .offset(x: 12, y: -6)
                            .rotationEffect(Angle.degrees(-60))
                            .frame(width: 25, height: nil, alignment: .center)
                    }
                    
                    Spacer()
                }.padding(.top)
            }
        }
    }
}
struct YAxisGridLines: View {
    @Environment(\.colorScheme) var colorScheme
    
    enum LabelType {
        case with(min: Double, max: Double, unit: String)
        case without
    }

    var numLines: Int
    var min: Double
    var max: Double
    
    // User is optionally allowed to pass in info for axis labels, default is without labels
    //
    var labelType: LabelType = .without

    var body: some View {

        let gridColor = UIColor.lightGray.withAlphaComponent(colorScheme == .dark ? 0.3 : 0.7)
        let incrementAmount = (max - 0)/Double(numLines)

        return GeometryReader { g in

            ZStack(alignment: .leading) {

                VStack(alignment: .center) {

                    ForEach(0...self.numLines, id: \.self) { index in

                        VStack(alignment: .leading, spacing: 0) {

                            if index != 0 {
                                Spacer()
                            }
                            
                            Text("\(Int(incrementAmount * Double(self.numLines - index)))")
                                .font(.caption)
                                .fontWeight(.regular)
                                .padding(.leading, 5)
                                .padding(.bottom, 0)

                            VStack {
                                Path{ path in
                                    path.move(to: CGPoint(x: 0, y: 0))
                                    path.addLine(to: CGPoint(x: g.size.width, y: 0))
                                }
                                .stroke(style: StrokeStyle( lineWidth: 1, dash: [1]))
                                .foregroundColor(Color(gridColor))
                            }
                            .foregroundColor(Color(gridColor))
                            .frame(width: g.size.width, height: 0.5)
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
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        let min = Double(data.min() ?? 0)
        let max = Double(data.max() ?? 0)
        let dataRange = CGFloat(max - 0)
        let barPadding: CGFloat = 1.0
        let chartPadding: CGFloat = (CGFloat(data.count) * barPadding)
        
        func xOffsetFor(index: Int, size: CGSize) -> CGFloat {
            let spaceForBar = (size.width - 40)/CGFloat(data.count)
            let offset = spaceForBar * CGFloat(index)
            return offset
        }

        return GeometryReader { g in
            ZStack(alignment: .bottomLeading) {

                YAxisGridLines(numLines: 5, min: min, max: max + Double(chartPadding))

                // Create the bars
                //
                ForEach(0..<self.data.count, id: \.self) { index in
                    bar(
                        height: ((g.size.height * 0.9) - chartPadding) * CGFloat(CGFloat(self.data[index])/dataRange),
                        width: (g.size.width - chartPadding)/CGFloat(self.data.count)
                    )
                        .offset(x: xOffsetFor(index: index, size: g.size), y: 0)
                }.padding(.leading, 40)
            }
        }
    }
}

struct BarChart: View {
    let chartTitle: String
    let unit: String
    let data: [(String, Int)]

    var body: some View {
        let labels = data.map { $0.0 }
        let values = data.map { $0.1 }

        return VStack(alignment: .center) {
            BarChartMidSection(data: values)

            XAxis(labels: labels)
                .padding(.leading, 20)
                .padding(.trailing, 20)
            
            Text("\(self.chartTitle)")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color(UIColor.label))
                .padding(.top)
        }
    }
}

struct BarChart_Previews: PreviewProvider {
    static var previews: some View {
        BarChart(
            chartTitle: "Simple, beautiful bar chart.",
            unit: "hi",
            data: [
                ("Sat", 10),
                ("Sun", 20),
                ("Mon", 60),
                ("Tues", 80),
                ("Wed", 10),
                ("Thu", 40),
                ("Fri", 60),
                ("Sat", 10),
                ("Sun", 30),
                ("Mon", 10),
                ("Tues", 0),
                ("Wed", 288),
                ("Thu", 20),
                ("Fri", 50)
            ]
        )
            .frame(height: 400).padding()
    }
}
