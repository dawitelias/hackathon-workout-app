//
//  Graph.swift
//  Workouts
//
//  Created by Emily Cheroske on 5/8/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

// This was taken and modified from Apple's SwiftUI tutorials (obviously modified to fit our use case, but lets give credit were it's due)

import SwiftUI
import HealthKit


func convertDataToRange(incrementAmount: Int, data: [Double]) -> [Range<Double>] {
    
    var ranges = [Range<Double>]()
    
    for index in stride(from: incrementAmount+1, to: data.count - incrementAmount + 1, by: incrementAmount) {
        let value1 = data[index - incrementAmount + 1]
        let value2 = data[index]
        
        if value1 > value2 {
            ranges.append(value2..<value1)
        } else {
            ranges.append(value1..<value2)
        }
    }
    
    return ranges
}

struct Graph: View {
    var rawData: [Double]
    var capsuleColor: Color = .gray
    var backgroundColor: Color = .black
    
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        let incrementAmount = (Double(rawData.count)/Double(screenWidth)) * 5
        let data = convertDataToRange(incrementAmount: Int(incrementAmount) + 1, data: rawData)

        let overallRange = (rawData.min() ?? 0)..<(rawData.max() ?? 0)

        return GeometryReader { proxy in
            VStack(alignment: .center, spacing: nil) {
                HStack(alignment: .bottom) {
                    HStack(alignment: .center, spacing: proxy.size.width / 200) {
                        ForEach(data.indices) { index in
                            GraphCapsule(
                                index: index,
                                height: proxy.size.height,
                                range: data[index],
                                overallRange: overallRange)
                            .colorMultiply(self.capsuleColor)
                        }
                    }
                    .padding(.top, 30)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                }
            }
        }
    }
}

struct Graph_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Graph(rawData: [
                1.0,
                12.0,
                6.0,
                4.0
            ],
            capsuleColor: .pink, backgroundColor: .black).frame(height: 200)
        }
    }
}
