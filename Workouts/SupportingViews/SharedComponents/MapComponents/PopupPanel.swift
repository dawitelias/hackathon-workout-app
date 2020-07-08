//
//  PopupPanel.swift
//  Workouts
//
//  Created by Emily Cheroske on 7/5/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI
import ArcGIS

func getAverageSpeed(segment: [AGSFeature]) -> Double {
    var speedSum: Double = 0
    segment.forEach { point in
        speedSum += point.attributes[WorkoutRouteAttributes.speed.rawValue] as? Double ?? 0
    }
    return speedSum/Double(segment.count)
}

// This returns the amount of elevation that a user gained taking into account
// their descents.
//
enum ElevationFormat {
    case gain, loss, net
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

struct PopupPanel: View {
    @Binding var selectedSegment: [AGSFeature]
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        let segmentStartDate = selectedSegment.last?.attributes[WorkoutRouteAttributes.timestamp.rawValue] as? Date ?? Date()
        let segmentEndDate = selectedSegment.first?.attributes[WorkoutRouteAttributes.timestamp.rawValue] as? Date ?? Date()
        let netElevationGain = getElevation(format: .net, segment: selectedSegment)
        let totalGain = getElevation(format: .gain, segment: selectedSegment)
        let totalLoss = getElevation(format: .loss, segment: selectedSegment)
        let segmentLength = getSegmentLength(segment: selectedSegment)
        
        let averageSpeed = getAverageSpeed(segment: selectedSegment)
        let minPerMilePace = metersPerSecondToMinPerMile(pace: averageSpeed)
        let minValue = Int(minPerMilePace)
        let secondsValue = Int(60 * minPerMilePace.truncatingRemainder(dividingBy: 1))
        let mphValue = metersPerSecondToMPH(pace: averageSpeed)
        
        let elapsedTime = abs(segmentStartDate.distance(to: segmentEndDate))
        let elapsedTimeString = elapsedTime > 60 ? elapsedTime.getHoursAndMinutesString() : "\(Int(elapsedTime))"
        let formattedMileageString = String(format: "%.2f", segmentLength)
        
        return VStack(alignment: .leading) {
            // Header for segment length and duration
            //
            HStack(alignment: .top) {
                Text("\(formattedMileageString)mi (\(elapsedTimeString)s)")
                    .font(.title)
                    .fontWeight(.semibold)
                    .frame(width: nil, height: 15, alignment: .center)
                    .padding(.top, 30)
                Spacer()
                Button(action: {
                    self.selectedSegment.removeAll()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 25, height: 25, alignment: .center)
                        .padding([.top, .bottom, .leading])
                })
            }.padding([.leading,.trailing])
            
            // Body for averages
            //
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text("Average Speed:")
                        .font(.callout)
                        .fontWeight(.heavy)
                    Text("\(minValue)'\(secondsValue)\" pace - \(String(format: "%.1f", mphValue)) mph")
                        .font(.callout)
                        .fontWeight(.thin)
                }.padding(.bottom, 5)
                HStack(alignment: .center) {
                    Text("Net Elevation Gain:")
                        .font(.callout)
                        .fontWeight(.heavy)
                    Text("\(Int(netElevationGain))ft")
                        .font(.callout)
                        .fontWeight(.thin)
                    Text("(+ \(Int(totalGain))ft")
                        .font(.footnote)
                        .foregroundColor(.green)
                    Text("\(Int(totalLoss))ft)")
                        .font(.footnote)
                        .foregroundColor(.red)
                }
                Text("\(segmentStartDate.hourAndMin) - \(segmentEndDate.hourAndMin)")
                    .font(.callout)
                    .fontWeight(.thin)
                    .padding(.top)
            }.padding([.leading, .trailing, .bottom])
        }
        .frame(width: UIScreen.main.bounds.width - 16, height: nil, alignment: .center)
        .background(Color(UIColor.secondarySystemBackground)
            .cornerRadius(10)
        .shadow(color: Color(colorScheme == .dark ? UIColor.black : UIColor.systemGray3), radius: 2, x: 1, y: 1)
        )
        .padding()
    }
}

struct PopupPanel_Previews: PreviewProvider {
    static var previews: some View {
        PopupPanel(selectedSegment: .constant([AGSFeature]()))
    }
}
