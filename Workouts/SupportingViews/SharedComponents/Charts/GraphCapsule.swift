//
//  GraphCapsule.swift
//  Workouts
//
//  Created by Emily Cheroske on 5/8/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

// This was literally taken straight from Apples own swiftui tutorials

import SwiftUI

struct GraphCapsule: View {
    var index: Int
    var height: CGFloat
    var range: Range<Double>
    var overallRange: Range<Double>
    
    var heightRatio: CGFloat {
        max(CGFloat((range.upperBound - range.lowerBound) / (overallRange.upperBound - overallRange.lowerBound)), 0.05)
    }
    
    var offsetRatio: CGFloat {
        CGFloat((range.lowerBound - overallRange.lowerBound) / (overallRange.upperBound - overallRange.lowerBound))
    }
    
    var body: some View {
        Capsule()
            .fill(Color.white)
            .frame(height: height * heightRatio)
            .offset(x: 0, y: height * -offsetRatio/2)
    }
}

struct GraphCapsule_Previews: PreviewProvider {
    static var previews: some View {
        GraphCapsule(index: 0, height: 150, range: 10..<50, overallRange: 0..<100)
    }
}
