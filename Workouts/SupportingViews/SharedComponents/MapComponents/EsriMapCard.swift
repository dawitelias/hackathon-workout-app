//
//  EsriMapCard.swift
//  Workouts
//
//  Created by Emily Cheroske on 7/5/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI
import ArcGIS
import CoreLocation

struct EsriMapCard: UIViewRepresentable {
    var route: [CLLocation]?

    @Environment(\.colorScheme) var colorScheme

    func makeUIView(context: Context) -> AGSMapView {
        let mapView = AGSMapView(frame: .zero)
        mapView.isAttributionTextVisible = false

        return mapView
    }
    func updateUIView(_ uiView: AGSMapView, context: Context) {
        
        // TODO: Save an image of this view, if the image exists, then DO NOT use the map,
        // just use the saved image!!!
        //
        
        guard let url = colorScheme == .dark ? URL(string: BasemapUrls.dark.rawValue) : URL(string: BasemapUrls.light.rawValue) else {
            return
        }
        let vectorTiledLayer = AGSArcGISVectorTiledLayer(url: url)
        let basemap = AGSBasemap(baseLayer: vectorTiledLayer)

        let map = AGSMap(basemap: basemap)

        uiView.map = map
        uiView.isUserInteractionEnabled = false

        guard let maxVelocity = route?.max(by: { return $0.speed < $1.speed })?.speed, let minVelocity = route?.min(by: { return $0.speed < $1.speed })?.speed else {
            return
        }

        // Define a line symbol for the route
        //
        var color = UIColor.clear
        
        // If there is no speed included in our location data then just make a plain orange route
        //
        color = maxVelocity != -1 && minVelocity != -1 ? color : .orange

        let lineSymbol = AGSSimpleLineSymbol(style: AGSSimpleLineSymbolStyle.solid, color: color, width: 5)
        let graphicsOverlay = AGSGraphicsOverlay()
        graphicsOverlay.renderer = AGSSimpleRenderer(symbol: lineSymbol)
        uiView.graphicsOverlays.remove(graphicsOverlay)
        uiView.graphicsOverlays.add(graphicsOverlay)

        // If we have received route data, add the graphic to the layer
        //
        if let workoutRoute = route {
            let points = workoutRoute.map { location in
                return AGSPoint(clLocationCoordinate2D: location.coordinate)
            }
            let lineGraphic = AGSGraphic(geometry: AGSPolyline(points: points), symbol: nil, attributes: nil)
            lineGraphic.zIndex = 0
            graphicsOverlay.graphics.add(lineGraphic)
            if let targetExtent = lineGraphic.geometry?.extent {
                uiView.setViewpoint(AGSViewpoint(targetExtent: targetExtent))
            }
        }
        
        // Add in the start and end graphics
        if let firstPoint = route?.first?.coordinate, let lastPoint = route?.last?.coordinate {
            let startCoordinate = AGSPoint(clLocationCoordinate2D: firstPoint)
            let endCoordinate = AGSPoint(clLocationCoordinate2D: lastPoint)
            
            let startSymbol = AGSPictureMarkerSymbol(image: UIImage(named: "RouteStart")!)
            let endSymbol = AGSPictureMarkerSymbol(image: UIImage(named: "RouteEnd")!)
            
            let startGraphic = AGSGraphic(geometry: startCoordinate, symbol: startSymbol, attributes: nil)
            let endGraphic = AGSGraphic(geometry: endCoordinate, symbol: endSymbol, attributes: nil)

            graphicsOverlay.graphics.add(startGraphic)
            graphicsOverlay.graphics.add(endGraphic)
        }

        if maxVelocity == -1 && minVelocity == -1 {
            return
        }

        let pointsCollectionTable = self.pointsCollectionTable()
        let featureCollection = AGSFeatureCollection(featureCollectionTables: [pointsCollectionTable])
        let featureCollectionLayer = AGSFeatureCollectionLayer(featureCollection: featureCollection)
        // Wait for the layer
        featureCollectionLayer.load { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            uiView.map?.operationalLayers.add(featureCollectionLayer)
        }
    }
    private func pointsCollectionTable() -> AGSFeatureCollectionTable {
        //create schema for points feature collection table
        var fields = [AGSField]()
        let speedField = AGSField(fieldType: .double, name: WorkoutRouteAttributes.speed.rawValue, alias: WorkoutRouteAttributes.speed.rawValue, length: 100, domain: nil, editable: true, allowNull: true)
        
        fields.append(speedField)

        // initialize feature collection table with the fields created
        // and geometry type as Point
        let pointsCollectionTable = AGSFeatureCollectionTable(fields: fields, geometryType: .point, spatialReference: .wgs84())
        
        // renderer
        let minValue: Double = 0
        var maxValue: Double = 0
        if let workoutRoute = route, let max = workoutRoute.map({ return $0.speed }).max() {
            maxValue = max
        }
        let colors: [UIColor] = [
            UIColor(named:"C_12")!,
            UIColor(named:"C_11")!,
            UIColor(named:"C_10")!,
            UIColor(named:"C_9")!,
            UIColor(named:"C_8")!,
            UIColor(named:"C_7")!,
            UIColor(named:"C_6")!,
            UIColor(named:"C_5")!,
            UIColor(named:"C_4")!,
            UIColor(named:"C_3")!,
            UIColor(named:"C_2")!,
            UIColor(named:"C_1")!
        ]
        var classBreaks = [AGSClassBreak]()
        let incrementAmount = (maxValue - minValue) / Double(colors.count)
        for i in 0...colors.count - 1 {
            classBreaks.append(AGSClassBreak(description: "\(i)", label: "\(i)", minValue: incrementAmount * Double(i), maxValue: (incrementAmount * Double(i)) + incrementAmount, symbol: AGSSimpleMarkerSymbol(style: .circle, color: colors[i], size: 5)))
        }

        let renderer = AGSClassBreaksRenderer(fieldName: WorkoutRouteAttributes.speed.rawValue, classBreaks: classBreaks)
        pointsCollectionTable.renderer = renderer
        
        // Create a new point feature, provide geometry and attribute values
        if var workoutRoute = route {
            workoutRoute = workoutRoute.filter { item in
                return item.horizontalAccuracy > 0 && item.coordinate.latitude != 0 && item.coordinate.longitude != 0
            }
            let density = Double(workoutRoute.count)/1000.0 // ? may  need to up this if memory is an issue
            let stepCount = density < 1 ? 1 : Int(density)
            
            for index in stride(from: 0, to: workoutRoute.count - stepCount, by: stepCount) {
                let pointFeature = pointsCollectionTable.createFeature()
                let point = AGSPoint(clLocationCoordinate2D: workoutRoute[index].coordinate)
                pointFeature.geometry = point
                pointFeature.attributes[WorkoutRouteAttributes.speed.rawValue] = workoutRoute[index].speed
                pointsCollectionTable.add(pointFeature, completion: nil)
            }
        }

        return pointsCollectionTable
    }
}

struct EsriMapCard_Previews: PreviewProvider {
    static var previews: some View {
        EsriMapCard(route: [
            CLLocation(latitude: 70.2568, longitude: 43.6591),
            CLLocation(latitude: 70.2578, longitude: 43.65978),
            CLLocation(latitude: 70.2548, longitude: 43.6548),
            CLLocation(latitude: 70.2538, longitude: 43.6538),
        ])
    }
}