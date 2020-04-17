//
//  MapImageGenerator.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/16/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

enum MapImageGeneratorErrors {
    case generalError, invalidPath
}

class MapImageGenerator {
    static func generateMapImageWithRoute(route: [CLLocation], completion: @escaping (UIImage?, Error?) -> Void) {
        let finalImageSize = CGSize(width: 400, height: 600)

        let options = MKMapSnapshotter.Options()
        options.mapType = .standard
        options.size = finalImageSize
        
        // Check if we have a valid route, insantiate a polyline off of the route
        // so that we can get the bounding box around the polygon where we want to center the map for
        // generating the image
        //
        if route.count > 0 {
             let polyline = MKGeodesicPolyline(coordinates: route.map { return CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude) }, count: route.count)
            options.mapRect = polyline.boundingMapRect
        }
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start() { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let generatedMapImage = snapshot, route.count > 1 else {
                return
            }

            UIGraphicsImageRenderer(size: finalImageSize).image { imageWithRoute in
                
                // Lay down the map image we generated first
                //
                generatedMapImage.image.draw(at: .zero)
                
                // Now we can start laying down our points
                //
                let points = route.map { coordinate in
                    generatedMapImage.point(for: CLLocationCoordinate2D(latitude: coordinate.coordinate.latitude, longitude: coordinate.coordinate.longitude))
                }
                
                let routePath = UIBezierPath()
                routePath.lineWidth = 2
                UIColor.orange.setStroke()
                
                routePath.move(to: points[0])

                for point in points.dropFirst() {
                    routePath.addLine(to: point)
                }

                routePath.stroke()
                
                completion(imageWithRoute.currentImage, nil)
            }
        }
    }
}
