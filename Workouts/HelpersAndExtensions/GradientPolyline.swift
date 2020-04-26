//
//  GradientPolyline.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/25/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import Foundation
import MapKit

// This gradient route code was inspired by but also modified from this Stack Overflow post: https://stackoverflow.com/questions/5682688/gradient-polyline-with-mapkit-ios
// My modifications: instead of specifying a static max/min velocity for determining the hue of the gradient, we are doing extra work to determine the min/max velocity values in the CLLocation array
// so that whatever route you are looking at - the speed is relative to itself. With the static values - a walk will show up all red, and a run will show up all green, we really want to compare it against itself
// when making these assumptions about how fast you are going. Also - instead of doing a bunch of checks (the example I based this off of on Stack Overflow was doing a ton of if vmax... else blah blah blah)
// We can make this code better by making color a function of where the velocity falls in the range between the min/max velocities of the entire route.
//
class GradientPolyline: MKPolyline {
    var colors: [UIColor]?
    public func getColor(from index: Int) -> CGColor {
        return colors?[index].cgColor ?? UIColor.yellow.cgColor
    }
}

extension GradientPolyline {
    convenience init(locations: [CLLocation], maxVelocity: Double, minVelocity: Double) {
        let coordinates = locations.map( { $0.coordinate } )
        self.init(coordinates: coordinates, count: coordinates.count)

        // We need to know the difference between these two values so that we can figure out where the velocity at a given index falls in that range % wise - this helps us calcaulte our color
        //
        let range: CGFloat = CGFloat(maxVelocity - minVelocity)

        colors = locations.map({
            let velocityIntentsity: CGFloat = CGFloat($0.speed - minVelocity)/range

            // hue from 0.03 to ~.3 is perfect for the red to green transition
            //
            return UIColor(hue: (velocityIntentsity * 0.3) + 0.03, saturation: 1, brightness: 1, alpha: 1)
        })
    }
}

class GradidentPolylineRenderer: MKPolylineRenderer {

    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        let boundingBox = self.path.boundingBox
        let mapRectCG = rect(for: mapRect)

        if(!mapRectCG.intersects(boundingBox)) { return }

        var prevColor: CGColor?
        var currentColor: CGColor?

        guard let polyLine = self.polyline as? GradientPolyline else { return }

        for index in 0...self.polyline.pointCount - 1{
            let point = self.point(for: self.polyline.points()[index])
            let path = CGMutablePath()

            currentColor = polyLine.getColor(from: index)

            if index == 0 {
               path.move(to: point)
            } else {
                let prevPoint = self.point(for: self.polyline.points()[index - 1])
                path.move(to: prevPoint)
                path.addLine(to: point)

                let colors = [prevColor!, currentColor!] as CFArray
                let baseWidth = self.lineWidth / zoomScale

                context.saveGState()
                context.addPath(path)

                let gradient = CGGradient(colorsSpace: nil, colors: colors, locations: [0, 1])

                context.setLineWidth(baseWidth)
                context.replacePathWithStrokedPath()
                context.clip()
                context.drawLinearGradient(gradient!, start: prevPoint, end: point, options: [])
                context.restoreGState()
            }
            prevColor = currentColor
        }
    }
}
