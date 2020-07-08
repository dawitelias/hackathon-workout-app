//
//  FullScreenMapView.swift
//  Workouts
//
//  Created by Emily Cheroske on 5/10/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI
import HealthKit
import CoreLocation
import MapKit
import ArcGIS

struct FullScreenMapView: View {
    let route: [CLLocation]
    @State var showShareSheet: Bool = false
    @State var selectedSegment: [AGSFeature] = [AGSFeature]()
    @State var mapView: AGSMapView = AGSMapView(frame: .zero)
    
    var body: some View {
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
        return ZStack(alignment: .bottom) {
            EsriMapView(route: route, isUserInteractionEnabled: true, selectedSegment: $selectedSegment, mapView: $mapView)
            
            if selectedSegment.count == 1 {
                CompleteSegmentPopup()
                    .transition(.slide)
                    .offset(x: 0, y: -40)
            }
            if selectedSegment.count > 1 {
                PopupPanel(selectedSegment: $selectedSegment)
                    .transition(.slide)
                    .offset(x: 0, y: -40)
            }
        }
        .edgesIgnoringSafeArea(.vertical)
        .navigationBarItems(trailing:
            Button(action: {
                if self.showShareSheet == false {
                    self.mapView.exportImage { image, error in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        guard let generatedImage = image else {
                            return
                        }
                        generatedMapImage = generatedImage
                        self.showShareSheet.toggle()
                    }
                } else {
                    self.showShareSheet.toggle()
                }
            }) {
                Image(systemName: "square.and.arrow.up").imageScale(.large)
            }.sheet(isPresented: $showShareSheet) {
                ShareSheet(activityItems: [generatedMapImage,
                "\(getInfoText())"])
            }
        )
    }
}

struct FullScreenMapView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenMapView(route: [
            CLLocation(latitude: 70.2568, longitude: 43.6591),
            CLLocation(latitude: 70.2578, longitude: 43.65978),
            CLLocation(latitude: 70.2548, longitude: 43.6548),
            CLLocation(latitude: 70.2538, longitude: 43.6538),
        ], selectedSegment: [AGSFeature]())
    }
}
