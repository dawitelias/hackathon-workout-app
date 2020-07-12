//
//  RouteCalculationsHelper.swift
//  Workouts
//
//  Created by Emily Cheroske on 7/10/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import Foundation
import CoreLocation
import ArcGIS

func getAverageSpeed(segment: [AGSFeature]) -> Double {
    var speedSum: Double = 0
    segment.forEach { point in
        speedSum += point.attributes[WorkoutRouteAttributes.speed.rawValue] as? Double ?? 0
    }
    return speedSum/Double(segment.count)
}

func getAverageSpeed(segment: [CLLocation]) -> Double {
    var speedSum: Double = 0
    segment.forEach { point in
        speedSum += point.speed
    }
    return speedSum/Double(segment.count)
}

func getPaceString(selectedSegment: [AGSFeature]) -> String {
    let averageSpeed = getAverageSpeed(segment: selectedSegment)
    let minPerMilePace = metersPerSecondToMinPerMile(pace: averageSpeed)
    let minValue = Int(minPerMilePace)
    let secondsValue = Int(60 * minPerMilePace.truncatingRemainder(dividingBy: 1))
    return "\(minValue)'\(String(format: "%02d", secondsValue))\" pace"
}

func getPaceString(route: [CLLocation]) -> String {
    let averageSpeed = getAverageSpeed(segment: route)
    let minPerMilePace = metersPerSecondToMinPerMile(pace: averageSpeed)
    let minValue = Int(minPerMilePace)
    let secondsValue = Int(60 * minPerMilePace.truncatingRemainder(dividingBy: 1))
    return "\(minValue)'\(String(format: "%02d", secondsValue))\" pace"
}

// This returns the amount of elevation that a user gained taking into account
// their descents.
//
enum ElevationFormat {
    case gain, loss, net
}

// Get the length of the selected segment using the geometry engine
//
func getSegmentLength(segment: [AGSFeature]) -> Double {
    var points = [AGSPoint]()
    segment.forEach { item in
        if let point = item.geometry as? AGSPoint {
            points.append(point)
        }
    }
    let line = AGSPolyline(points: points)
    let lineLength = AGSGeometryEngine.geodeticLength(of: line, lengthUnit: .miles(), curveType: .geodesic)
    return lineLength
}

func getElevation(format: ElevationFormat, segment: [AGSFeature]) -> Double {
    guard segment.count >= 1 else {
        return 0
    }
    let reversed = segment.reversed() as [AGSFeature]
    var sumValue: Double = 0
    for i in 1...(reversed.count - 1) {
        if let currentElevation = reversed[i].attributes[WorkoutRouteAttributes.elevation.rawValue] as? Double,
            let previousElevation = reversed[i-1].attributes[WorkoutRouteAttributes.elevation.rawValue] as? Double {
            let difference = currentElevation - previousElevation
            switch format {
            case .gain:
                sumValue += max(0, difference)
            case .loss:
                sumValue += min(0, difference)
            case .net:
                sumValue += difference
            }
        }
    }
    
    return metersToFeet(meters: sumValue)
}

func getElevation(format: ElevationFormat, segment: [CLLocation]) -> Double {
    guard segment.count >= 1 else {
        return 0
    }
    let reversed = segment as [CLLocation]
    var sumValue: Double = 0
    for i in 1...(reversed.count - 1) {
        let currentElevation = reversed[i].altitude
        let previousElevation = reversed[i - 1].altitude
        let difference = currentElevation - previousElevation
        switch format {
        case .gain:
            sumValue += max(0, difference)
        case .loss:
            sumValue += min(0, difference)
        case .net:
            sumValue += difference
        }
    }
    
    return metersToFeet(meters: sumValue)
}
