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

var generatedMapImage: UIImage = UIImage()

struct FullScreenMapView: View {

    let route: [CLLocation]

    @State var showShareSheet: Bool = false
    @State var selectedSegment: [AGSFeature] = [AGSFeature]()
    @State var mapView: AGSMapView = AGSMapView(frame: .zero)
    
    private func getInfoText() -> String {

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

    var body: some View {

        return ZStack(alignment: .bottom) {

            EsriMapView(route: route, isUserInteractionEnabled: true, selectedSegment: $selectedSegment, mapView: $mapView)
            
            if selectedSegment.count == 1 {
                SlidingPanel {
                    VStack {
                        Text(Strings.selectPointPrompt)
                            .font(.headline)
                        Spacer()
                    }
                }
            }

            if selectedSegment.count > 1 {
                SlidingPanel {
                    VStack {
                        Text("SEGMENT!")
                            .font(.headline)
                        Spacer()
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.vertical)
        .navigationBarItems(trailing:

            Button(action: {

                if showShareSheet == false {

                    mapView.exportImage { image, error in

                        guard error == nil, let generatedImage = image else {
                            return
                        }

                        generatedMapImage = generatedImage
                        showShareSheet.toggle()

                    }

                } else {

                    showShareSheet.toggle()

                }

            }) {

                Image(systemName: Images.shareIcon.rawValue).imageScale(.large)

            }.sheet(isPresented: $showShareSheet) {

                ShareSheet(activityItems: [generatedMapImage, getInfoText()])

            }
        )
    }
}

// MARK: Strings and assets
//
extension FullScreenMapView {

    private enum Images: String {
        case shareIcon = "square.and.arrow.up"
    }

    private struct Strings {

        static var selectPointPrompt: String {
            NSLocalizedString("com.okapi.fullScreenMap.selectPoint", value: "Select another point to complete the segment", comment: "Prompt the user to select another point on the map.")
        }

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
