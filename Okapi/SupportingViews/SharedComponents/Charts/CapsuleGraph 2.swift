//
//  CapsuleGraph.swift
//  Workouts
//
//  Created by Emily Cheroske on 7/15/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct CapsuleInfo: Hashable {
    var verticalHeightPercentage: Double // percentage of vertical space the capsule should fill
    var verticalOffsetPercentage: Double // percentage along yaxis the capsule should fall (starting from bottom)
}

struct CapsuleGraph: View {
    var data: [Double]
    var showAxisLabels: Bool
    var capsuleColor: Color
    var units: String
    let minimumCapsuleWidth = 3

    @State var frame: CGSize = .zero

    var chartPadding: CGFloat {
        return showAxisLabels ? 40 : 0
    }
    var chartBodyWidth: CGFloat {
        let width = frame.width - CGFloat(chartPadding)
        return width
    }
    
    func makeView(_ geometry: GeometryProxy) -> some View {
        print(geometry.size.width, geometry.size.height)

        DispatchQueue.main.async { self.frame = geometry.size }

        return Text("Loading.")
                .frame(width: geometry.size.width)
    }

    func capsuleWidth(numDataPoints: Int) -> CGFloat {
        // We need to preserve 1px of spacing after each capsule, so factor this into the width
        //
        let minimumCapsuleWidth: CGFloat = 3
        let desiredWidth = (chartBodyWidth/CGFloat(numDataPoints))
        return desiredWidth > minimumCapsuleWidth ? desiredWidth : minimumCapsuleWidth
    }

    func getStepByIncrement(numDataPoints: Int) -> Int {
        let minimumCapsuleWidth = capsuleWidth(numDataPoints: numDataPoints)
        let incrementAmount = CGFloat(data.count)/chartBodyWidth * CGFloat(minimumCapsuleWidth)
        return incrementAmount < 1 ? 1 : Int(incrementAmount + 1.0)
    }
    
    // We want to calculate the difference between every x^th data point depending on how much screen real estate
    // we have available
    //
    func getCapsuleData() -> [CapsuleInfo] {
        guard self.frame != .zero, data.count != 0 else {
            return [CapsuleInfo]()
        }
        var capsules = [CapsuleInfo]()
        
        let incrementAmount: Int = getStepByIncrement(numDataPoints: data.count)
        
        var dataMax = data.max() ?? 0
        let dataMin = data.min() ?? 0

        dataMax = dataMax - dataMin
        
        let normalizedData = data.map { dataPoint in
            return ((dataPoint - dataMin)/dataMax) * 100
        }

        for i in stride(from: incrementAmount, to: data.count - incrementAmount, by: incrementAmount) {
            let currentItem = normalizedData[i]
            let previousItem = normalizedData[i-Int(incrementAmount)]
            let difference = abs(currentItem - previousItem)
            let verticalPercentage = difference/100
            let bottomOfCapsule = min(previousItem, currentItem)
            let verticalOffset = bottomOfCapsule/100

            capsules.append(CapsuleInfo(verticalHeightPercentage: verticalPercentage, verticalOffsetPercentage: verticalOffset))
        }
        return capsules
    }

    var body: some View {
        let capsules: [CapsuleInfo] = getCapsuleData()

        return GeometryReader { g in
            if self.frame == .zero || capsules.count == 0 {
                 self.makeView(g)
            } else {
                Text("Max - \(Int(self.data.max() ?? 0)) \(self.units)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .offset(x: 0, y: -15)
                    .padding(.leading, 5)
                    .foregroundColor(Color.gray)

                ZStack(alignment: .bottomLeading) {
                    // YAxis Grid Lines
                    //
                    YAxisGridLines(numLines: 5, min: self.data.min() ?? 0, max: self.data.max() ?? 0)

                    ForEach(0...capsules.count - 1, id: \.self) { i in
                        Capsule()
                            .fill(self.capsuleColor)
                            .frame(
                                width: self.capsuleWidth(numDataPoints: capsules.count) - 1,
                                height: g.size.height * CGFloat(capsules[i].verticalHeightPercentage) + 1)
                            .offset(
                                x: self.capsuleWidth(numDataPoints: capsules.count) * CGFloat(i) + self.chartPadding - 10,
                                y: -g.size.height * CGFloat(capsules[i].verticalOffsetPercentage))
                    }
                }.padding(0)
            }
        }.padding(0)
    }
}

struct CapsuleGraph_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleGraph(data: [
                Double.random(in: 80...150),
                Double.random(in: 80...150),
                Double.random(in: 80...150),
                Double.random(in: 80...150),
                Double.random(in: 80...150),
                Double.random(in: 80...150),
                Double.random(in: 80...150),
                Double.random(in: 80...150),
                Double.random(in: 80...150),
                Double.random(in: 80...150),
                Double.random(in: 80...150),
                Double.random(in: 80...150),
                Double.random(in: 80...150),
                Double.random(in: 80...150),
                Double.random(in: 80...150),
                Double.random(in: 80...150),
                Double.random(in: 80...150),
                Double.random(in: 80...150),
                Double.random(in: 80...150),
                Double.random(in: 80...150)
        ],
                     showAxisLabels: true,
                     capsuleColor: Color.pink,
                     units: "bmp"
        ).frame(height: 300)
    }
}
