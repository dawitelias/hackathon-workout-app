//
//  FullScreenMapViewModel.swift
//  Workouts
//
//  Created by Emily Cheroske on 1/18/21.
//  Copyright © 2021 Dawit Elias. All rights reserved.
//

import Foundation
import CoreLocation
import ArcGIS

class FullScreenMapViewModel: ObservableObject {
    
    let route: [CLLocation]?

    let settings: UserSettings

    @Published var selectedSegment: [AGSFeature] = [AGSFeature]()
    
    init(route: [CLLocation], settings: UserSettings) {

        self.route = route

        self.settings = settings

    }
    
    public var segmentStartDate: Date {

        selectedSegment.last?.attributes[WorkoutRouteAttributes.timestamp.rawValue] as? Date ?? Date()

    }
    
    public var segmentEndDate: Date {

        selectedSegment.first?.attributes[WorkoutRouteAttributes.timestamp.rawValue] as? Date ?? Date()

    }
    
    public var netElevationGain: Double {
        
        getElevation(format: .net, segment: selectedSegment, settings: settings)

    }
    
    public var totalGain: Double {

        getElevation(format: .gain, segment: selectedSegment, settings: settings)

    }
    
    public var totalLoss: Double {

        getElevation(format: .loss, segment: selectedSegment, settings: settings)

    }
    
    public var segmentLength: Double {

        getSegmentLength(segment: selectedSegment, settings: settings)

    }
    
    public var averageSpeed: Double {

        getAverageSpeed(segment: selectedSegment, settings: settings)

    }
    
    public var mphValue: Double {

        metersPerSecondToMPH(pace: averageSpeed)

    }
    public var kphValue: Double {
        
        metersPerSecondToKPH(pace: averageSpeed)

    }
    
    public var elapsedTime: Double {

        abs(segmentStartDate.distance(to: segmentEndDate))

    }
    
    public var elapsedTimeString: String {

        elapsedTime > 60 ? elapsedTime.getHoursAndMinutesString() : "\(Int(elapsedTime))"

    }

    public var speedText: String {

        let paceString = settings.userUnitPreferences == .usImperial ? getPaceString(milesPerHour: mphValue) : getPaceString(kilometersPerHour: kphValue)

        return "\(paceString) - \(String(format: "%.1f", settings.userUnitPreferences == .usImperial ? mphValue : kphValue)) \(settings.userUnitPreferences.speed)"

    }
    
    public var elevationGainText: String {

        "\(Int(netElevationGain))\(settings.userUnitPreferences.abbreviatedElevationUnit), (+ \(Int(totalGain))\(settings.userUnitPreferences.abbreviatedElevationUnit), \(Int(totalLoss))\(settings.userUnitPreferences.abbreviatedElevationUnit))"

    }

    func getInfoText() -> String {

        var value = ""

        if selectedSegment.count > 1 {

            let segmentStartDate = selectedSegment.last?.attributes[WorkoutRouteAttributes.timestamp.rawValue] as? Date ?? Date()
            let segmentEndDate = selectedSegment.first?.attributes[WorkoutRouteAttributes.timestamp.rawValue] as? Date ?? Date()
            let elapsedTime = abs(segmentStartDate.distance(to: segmentEndDate))
            let elapsedTimeString = elapsedTime > 60 ? elapsedTime.getHoursAndMinutesString() : "\(Int(elapsedTime))s"
            let segmentLength = getSegmentLength(segment: selectedSegment, settings: settings)

            let formattedLengthString = String(format: "%.2f", segmentLength)
            value = "Selected Segment: \(elapsedTimeString), \(formattedLengthString)\(settings.userUnitPreferences.abbreviatedDistanceUnit)"

        } else {

            value = ChuckNorris.getRandomChuckNorrisQuote()

        }

        return value
    }

}
