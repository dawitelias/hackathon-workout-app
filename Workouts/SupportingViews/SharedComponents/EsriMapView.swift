//
//  MapView.swift
//  SwiftUIFun
//
//  Created by Emily Cheroske on 4/10/20.
//  Copyright © 2020 Emily Cheroske. All rights reserved.
//

//import SwiftUI
//import ArcGIS
//import CoreLocation
//
//struct EsriMapView: UIViewRepresentable {
//    var route: [CLLocationCoordinate2D]?
//    
//    func makeUIView(context: Context) -> AGSMapView {
//        let mapView = AGSMapView(frame: .zero)
//        mapView.isAttributionTextVisible = false
//        
//        return mapView
//    }
//    func updateUIView(_ uiView: AGSMapView, context: Context) {
//
//        let map = AGSMap(basemap: .darkGrayCanvasVector())
//        
//        uiView.map = map
//        
//        // Define a line symbol for the route
//        //
//        let lineSymbol = AGSSimpleLineSymbol(style: AGSSimpleLineSymbolStyle.solid, color: .orange, width: 3)
//        let graphicsOverlay = AGSGraphicsOverlay()
//        graphicsOverlay.renderer = AGSSimpleRenderer(symbol: lineSymbol)
//        uiView.graphicsOverlays.add(graphicsOverlay)
//        // If we have received route data, add the graphic to the layer
//        //
//        if let workoutRoute = route {
//            let points = workoutRoute.map { location in
//                return AGSPoint(clLocationCoordinate2D: location)
//            }
//            let lineGraphic = AGSGraphic(geometry: AGSPolyline(points: points), symbol: nil, attributes: nil)
//            graphicsOverlay.graphics.add(lineGraphic)
//            if let targetExtent = lineGraphic.geometry?.extent {
//                print("setting mapViewViewpoint")
//                uiView.setViewpoint(AGSViewpoint(targetExtent: targetExtent))
//            } else {
//                print("no extent found")
//            }
//        }
//    }
//}
//
//struct EsriMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        EsriMapView(route: [
//            CLLocationCoordinate2D(latitude: 70.2568, longitude: 43.6591),
//            CLLocationCoordinate2D(latitude: 70.2578, longitude: 43.65978),
//            CLLocationCoordinate2D(latitude: 70.2548, longitude: 43.6548),
//            CLLocationCoordinate2D(latitude: 70.2538, longitude: 43.6538),
//        ])
//    }
//}
