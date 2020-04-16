//
//  MapView.swift
//  HealthKitSwiftUI
//
//  Created by Emily Cheroske on 4/14/20.
//  Copyright © 2020 Emily Cheroske. All rights reserved.
//

import SwiftUI
import MapKit
import HealthKit

struct MapView: UIViewRepresentable {
    var workout: HKWorkout
    let mapViewDelegate = MapViewDelegate()

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.delegate = mapViewDelegate

        workout.getWorkoutLocationData() { route, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let myRoute = route {
                let polyline = MKGeodesicPolyline(coordinates: myRoute, count: myRoute.count)
                uiView.setVisibleMapRect(polyline.boundingMapRect, animated: true)
                uiView.addOverlay(polyline)
            }
            
        }
    }
}

class MapViewDelegate: NSObject, MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.fillColor = UIColor.yellow.withAlphaComponent(0.5)
        renderer.strokeColor = UIColor.orange.withAlphaComponent(0.8)
        return renderer
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(workout: HKWorkout(activityType: .running, start: Date(), end: Date()))
    }
}
