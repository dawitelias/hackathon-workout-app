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

    @Published var selectedSegment: [AGSFeature] = [AGSFeature]()
    
    init(route: [CLLocation]) {

        self.route = route

    }
    
    public var segmentStartDate: Date {

        selectedSegment.last?.attributes[WorkoutRouteAttributes.timestamp.rawValue] as? Date ?? Date()

    }
    
    public var segmentEndDate: Date {

        selectedSegment.first?.attributes[WorkoutRouteAttributes.timestamp.rawValue] as? Date ?? Date()

    }
    
    public var netElevationGain: Double {
        
        getElevation(format: .net, segment: selectedSegment)

    }
    
    public var totalGain: Double {

        getElevation(format: .gain, segment: selectedSegment)

    }
    
    public var totalLoss: Double {

        getElevation(format: .loss, segment: selectedSegment)

    }
    
    public var segmentLength: Double {

        getSegmentLength(segment: selectedSegment)

    }
    
    public var averageSpeed: Double {

        getAverageSpeed(segment: selectedSegment)

    }
    
    public var mphValue: Double {

        metersPerSecondToMPH(pace: averageSpeed)

    }
    
    public var elapsedTime: Double {

        abs(segmentStartDate.distance(to: segmentEndDate))

    }
    
    public var elapsedTimeString: String {

        elapsedTime > 60 ? elapsedTime.getHoursAndMinutesString() : "\(Int(elapsedTime))"

    }

    public var speedText: String {

        "\(getPaceString(selectedSegment: selectedSegment)) - \(String(format: "%.1f", mphValue)) mph"

    }
    
    public var elevationGainText: String {

        "\(Int(netElevationGain))ft, (+ \(Int(totalGain))ft, \(Int(totalLoss))ft)"

    }

    func getInfoText() -> String {

        var value = ""

        if selectedSegment.count > 1 {

            let segmentStartDate = selectedSegment.last?.attributes[WorkoutRouteAttributes.timestamp.rawValue] as? Date ?? Date()
            let segmentEndDate = selectedSegment.first?.attributes[WorkoutRouteAttributes.timestamp.rawValue] as? Date ?? Date()
            let elapsedTime = abs(segmentStartDate.distance(to: segmentEndDate))
            let elapsedTimeString = elapsedTime > 60 ? elapsedTime.getHoursAndMinutesString() : "\(Int(elapsedTime))s"
            let segmentLength = getSegmentLength(segment: selectedSegment)

            let formattedMileageString = String(format: "%.2f", segmentLength)
            value = "Selected Segment: \(elapsedTimeString), \(formattedMileageString)mi, \(getPaceString(selectedSegment: selectedSegment))"

        } else {

            value = ChuckNorris.getRandomChuckNorrisQuote()

        }

        return value
    }

}
