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

// Average speed in meters / second
//
func getAverageSpeed(segment: [AGSFeature], settings: UserSettings) -> Double {
    var speedSum: Double = 0
    segment.forEach { point in
        speedSum += point.attributes[WorkoutRouteAttributes.speed.rawValue] as? Double ?? 0
    }
    return speedSum/Double(segment.count)
}

// Average speed in meters / second
//
func getAverageSpeed(segment: [CLLocation], settings: UserSettings) -> Double {
    var speedSum: Double = 0
    segment.forEach { point in
        speedSum += point.speed
    }
    return speedSum/Double(segment.count)
}

func getPaceString(milesPerHour: Double) -> String {

    // TODO: Crash here sometimes :(
    //
    let pace = milesPerHour > 0 ? 60 / milesPerHour : 0
    let minVal = Int(pace)
    let secondsVal = Int(60 * pace.truncatingRemainder(dividingBy: 1))

    return "\(minVal)'\(String(format: "%02d", secondsVal))\" pace"
}

func getPaceString(kilometersPerHour: Double) -> String {
    let pace = kilometersPerHour > 0 ? 60 / kilometersPerHour : 0
    let minVal = Int(pace)
    let secondsVal = Int(60 * pace.truncatingRemainder(dividingBy: 1))

    return "\(minVal)'\(String(format: "%02d", secondsVal))\" pace"
}

// This returns the amount of elevation that a user gained taking into account
// their descents.
//
enum ElevationFormat {
    case gain, loss, net
}

// Get the length of the selected segment using the geometry engine
//
func getSegmentLength(segment: [AGSFeature], settings: UserSettings) -> Double {

    var points = [AGSPoint]()

    segment.forEach { item in
        if let point = item.geometry as? AGSPoint {
            points.append(point)
        }
    }

    let line = AGSPolyline(points: points)

    return AGSGeometryEngine.geodeticLength(of: line, lengthUnit: settings.userUnitPreferences == .metric ? .kilometers() : .miles(), curveType: .geodesic)
}

func getElevation(format: ElevationFormat, segment: [AGSFeature], settings: UserSettings) -> Double {
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
    
    return settings.userUnitPreferences == .metric ? sumValue : metersToFeet(meters: sumValue)
}

func getElevation(format: ElevationFormat, segment: [CLLocation], settings: UserSettings) -> Double {
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

    return settings.userUnitPreferences == .metric ? sumValue : metersToFeet(meters: sumValue)
}
