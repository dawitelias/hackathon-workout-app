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

class StartAnnotation: NSObject, MKAnnotation {
    @objc dynamic var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.779_379, longitude: -143.418_433)
    var title: String? = NSLocalizedString("Route Start", comment: "Start Title text")
    var subtitle: String? = NSLocalizedString("subtitle text", comment: "Subtitle text")
    var leftImageName: String?
}

class EndAnnotation: NSObject, MKAnnotation {
    @objc dynamic var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var title: String? = NSLocalizedString("Route End", comment: "Route end text")
    var subtitle: String? = NSLocalizedString("subtitle text", comment: "Subtitle text")
    var leftImageName: String?
}

struct MapView: UIViewRepresentable {
    var workout: HKWorkout
    var isUserInteractionEnabled: Bool
    let mapViewDelegate = MapViewDelegate()
    
    @State var route: [CLLocation]? = nil
    @State var startAnnotation: StartAnnotation?
    @State var endAnnotation: EndAnnotation?

    func makeUIView(context: Context) -> MKMapView {
        workout.getWorkoutLocationData { route, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let myRoute = route, myRoute.count > 0, let startCoordinate = myRoute.first, let endCoordinate = myRoute.last {
                self.route = myRoute
                
                let startPointAnnotation = StartAnnotation()
                startPointAnnotation.coordinate = startCoordinate.coordinate
                startPointAnnotation.subtitle = startCoordinate.timestamp.date
                startPointAnnotation.title = "Started: \(self.workout.workoutActivityType.workoutTypeMetadata.activityTypeDescription) 💪"
                //startPointAnnotation.leftImageName = self.workout.workoutActivityType.workoutTypeMetadata.systemIconName
                
                let endPointAnnotation = EndAnnotation()
                endPointAnnotation.coordinate = endCoordinate.coordinate
                endPointAnnotation.subtitle = endCoordinate.timestamp.date
                endPointAnnotation.title = "Finished: \(self.workout.workoutActivityType.workoutTypeMetadata.activityTypeDescription) 🏅"
                //endPointAnnotation.leftImageName = self.workout.workoutActivityType.workoutTypeMetadata.systemIconName
                
                self.startAnnotation = startPointAnnotation
                self.endAnnotation = endPointAnnotation
            }
        }
        let mapView = MKMapView(frame: .zero)
        mapView.isUserInteractionEnabled = isUserInteractionEnabled
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.delegate = mapViewDelegate
        uiView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(StartAnnotation.self))
        uiView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(EndAnnotation.self))
    
        uiView.removeAnnotations(uiView.annotations)
        if let startAnn = self.startAnnotation, let endAnn = self.endAnnotation {
            uiView.addAnnotation(startAnn)
            uiView.addAnnotation(endAnn)
        }

        if let myRoute = self.route {
            guard let maxVelocity = myRoute.max(by: { return $0.speed < $1.speed })?.speed, let minVelocity = myRoute.min(by: { return $0.speed < $1.speed })?.speed else {
                return
            }
            
            // If our location data doesn't have speed information associated with the route, then we just want to render out a plain orange? line
            //
            if maxVelocity == -1 && minVelocity == -1 {
                let polyline = MKGeodesicPolyline(coordinates: myRoute.map { return CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude) }, count: myRoute.count)
                uiView.setVisibleMapRect(polyline.boundingMapRect, animated: false)
                uiView.addOverlay(polyline)
            } else {
                let polyline = GradientPolyline(locations: myRoute, maxVelocity: maxVelocity, minVelocity: minVelocity)
                uiView.setVisibleMapRect(polyline.boundingMapRect, animated: false)
                uiView.addOverlay(polyline)
            }
        }
    }
}

class MapViewDelegate: NSObject, MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        if overlay is GradientPolyline {
            let renderer = GradidentPolylineRenderer(overlay: overlay)
            renderer.lineWidth = 8
            return renderer
        }

        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 5
        renderer.strokeColor = UIColor.orange.withAlphaComponent(0.8)

        return renderer
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        var annotationView: MKAnnotationView?

        if let annotation = annotation as? StartAnnotation {
            annotationView = setupStartImage(for: annotation, on: mapView)
        } else if let annotation = annotation as? EndAnnotation {
            annotationView = setupEndImage(for: annotation, on: mapView)
        }

        return annotationView
    }

    private func setupStartImage(for annotation: StartAnnotation, on mapView: MKMapView) -> MKMarkerAnnotationView {
        let reuseIdentifier = NSStringFromClass(StartAnnotation.self)
        let startAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation) as! MKMarkerAnnotationView

        startAnnotationView.canShowCallout = true

        startAnnotationView.markerTintColor = UIColor.systemGreen
        startAnnotationView.glyphImage = UIImage(named: "RouteStart")!
        startAnnotationView.glyphTintColor = UIColor.white
        startAnnotationView.titleVisibility = .hidden
        startAnnotationView.displayPriority = .required
        
        if let leftImage = annotation.leftImageName {
            startAnnotationView.leftCalloutAccessoryView = UIImageView(image: UIImage(named: leftImage)!)
        }

        return startAnnotationView
    }

    private func setupEndImage(for annotation: EndAnnotation, on mapView: MKMapView) -> MKMarkerAnnotationView {
        let reuseIdentifier = NSStringFromClass(EndAnnotation.self)
        let endAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation) as! MKMarkerAnnotationView
        
        endAnnotationView.canShowCallout = true

        endAnnotationView.glyphImage = UIImage(named: "RouteEnd")!
        endAnnotationView.glyphTintColor = UIColor.white
        endAnnotationView.titleVisibility = .hidden
        endAnnotationView.displayPriority = .required
        
        if let leftImage = annotation.leftImageName {
            endAnnotationView.leftCalloutAccessoryView = UIImageView(image: UIImage(named: leftImage)!)
        }

        return endAnnotationView
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(workout: HKWorkout(activityType: .running, start: Date(), end: Date()), isUserInteractionEnabled: true, startAnnotation: StartAnnotation(), endAnnotation: EndAnnotation())
    }
}
