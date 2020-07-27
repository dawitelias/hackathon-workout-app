//
//  PopupPanel.swift
//  Workouts
//
//  Created by Emily Cheroske on 7/5/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI
import ArcGIS

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
                    Text("\(getPaceString(selectedSegment: selectedSegment)) - \(String(format: "%.1f", mphValue)) mph")
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
        .frame(width: UIScreen.main.bounds.width - 8, height: nil, alignment: .center)
        .background(Blur().cornerRadius(5).shadow(color: Color(colorScheme == .dark ? UIColor.black : UIColor.systemGray3), radius: 2, x: 0, y: 0)
        )
        .padding()
    }
}

struct PopupPanel_Previews: PreviewProvider {
    static var previews: some View {
        PopupPanel(selectedSegment: .constant([AGSFeature]()))
    }
}
