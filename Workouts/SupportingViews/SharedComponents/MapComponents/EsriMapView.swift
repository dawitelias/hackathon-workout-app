//
//  MapView.swift
//  SwiftUIFun
//
//  Created by Emily Cheroske on 4/10/20.
//  Copyright © 2020 Emily Cheroske. All rights reserved.
//

import SwiftUI
import ArcGIS
import CoreLocation

var lightOrDark: ColorScheme?

enum WorkoutRouteAttributes: String {
    case elevation = "Elevation"
    case speed = "Speed"
    case index = "PointIndex"
    case timestamp = "Timestamp"
}
enum BasemapUrls: String {
    case light = "https://emilcheroske.maps.arcgis.com/home/item.html?id=1becad86ac93425eb3fd2343e4507359"
    case dark = "https://emilcheroske.maps.arcgis.com/home/item.html?id=6f4816759ad34e66b2b5a1c15e51f8e0"
}

struct EsriMapView: UIViewRepresentable {
    var route: [CLLocation]?
    var isUserInteractionEnabled: Bool = false

    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedSegment: [AGSFeature]
    @Binding var mapView: AGSMapView

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> AGSMapView {
        mapView.isAttributionTextVisible = false
        mapView.touchDelegate = context.coordinator
        mapView.selectionProperties.color = .cyan

        lightOrDark = colorScheme
        if let url = colorScheme == .dark ? URL(string: BasemapUrls.dark.rawValue) : URL(string: BasemapUrls.light.rawValue) {
            let vectorTiledLayer = AGSArcGISVectorTiledLayer(url: url)
            let basemap = AGSBasemap(baseLayer: vectorTiledLayer)

            let map = AGSMap(basemap: basemap)

            mapView.map = map
            mapView.isUserInteractionEnabled = isUserInteractionEnabled

            drawRoute(uiView: mapView)
        }

        return mapView
    }
    func updateUIView(_ uiView: AGSMapView, context: Context) {
        if selectedSegment.count <= 0 {
            if let featureCollectionLayer = uiView.map?.operationalLayers.firstObject as? AGSFeatureCollectionLayer, let featureLayer = featureCollectionLayer.layers.first {
                featureLayer.clearSelection()
            }
        }
        if lightOrDark != nil && lightOrDark != colorScheme {
            lightOrDark = colorScheme
            if let url = colorScheme == .dark ? URL(string: BasemapUrls.dark.rawValue) : URL(string: BasemapUrls.light.rawValue) {
                let vectorTiledLayer = AGSArcGISVectorTiledLayer(url: url)
                let basemap = AGSBasemap(baseLayer: vectorTiledLayer)
    
                uiView.map?.basemap = basemap
                uiView.reloadInputViews()
            }
        }
    }
    
    private func drawRoute(uiView: AGSMapView) {
        guard let maxVelocity = route?.max(by: { return $0.speed < $1.speed })?.speed, let minVelocity = route?.min(by: { return $0.speed < $1.speed })?.speed else {
            return
        }

        // Define a line symbol for the route
        //
        var color = isUserInteractionEnabled ? UIColor.lightGray.withAlphaComponent(0.15) : UIColor.clear
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
        let elevationField = AGSField(fieldType: .double, name: WorkoutRouteAttributes.elevation.rawValue, alias: WorkoutRouteAttributes.elevation.rawValue, length: 100, domain: nil, editable: true, allowNull: true)
        let timestamp = AGSField(fieldType: .date, name: WorkoutRouteAttributes.timestamp.rawValue, alias: WorkoutRouteAttributes.timestamp.rawValue, length: 100, domain: nil, editable: true, allowNull: true)
        let indexField = AGSField(fieldType: .int32, name: WorkoutRouteAttributes.index.rawValue, alias: WorkoutRouteAttributes.index.rawValue, length: 100, domain: nil, editable: true, allowNull: false)
        
        fields.append(speedField)
        fields.append(elevationField)
        fields.append(timestamp)
        fields.append(indexField)

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

            let stepCount = 1
            for index in stride(from: 0, to: workoutRoute.count - stepCount, by: stepCount) {
                let pointFeature = pointsCollectionTable.createFeature()
                let point = AGSPoint(clLocationCoordinate2D: workoutRoute[index].coordinate)
                pointFeature.geometry = point
                pointFeature.attributes[WorkoutRouteAttributes.elevation.rawValue] = workoutRoute[index].altitude
                pointFeature.attributes[WorkoutRouteAttributes.speed.rawValue] = workoutRoute[index].speed
                pointFeature.attributes[WorkoutRouteAttributes.index.rawValue] = index
                pointFeature.attributes[WorkoutRouteAttributes.timestamp.rawValue] = workoutRoute[index].timestamp
                pointsCollectionTable.add(pointFeature, completion: nil)
            }
        }

        return pointsCollectionTable
    }
    // MARK: Coordinator
    //
    class Coordinator: NSObject, AGSGeoViewTouchDelegate {
        var parent: EsriMapView

        init(_ item: EsriMapView) {
            self.parent = item
        }
        func selectFeatures(feature: AGSFeature, featureLayer: AGSFeatureLayer) {
            // If there is only one point in our existing segment, then just append this point and
            // select it without doing anything else,
            //
            if parent.selectedSegment.count == 0 {
                parent.selectedSegment.append(feature)
                featureLayer.select(feature)
                return
            }
    
            // We can assume the user has already defined a starting point for the segment - now we can
            // continue with the logic to highlight/select wherever else they tap
            //
            let startValue = parent.selectedSegment[Int(parent.selectedSegment.count/2)].attributes[WorkoutRouteAttributes.index.rawValue] as! Int
            let endValue = feature.attributes[WorkoutRouteAttributes.index.rawValue] as! Int
    
            let queryParams = AGSQueryParameters()
            queryParams.whereClause = "\(WorkoutRouteAttributes.index.rawValue) BETWEEN \(startValue < endValue ? startValue : endValue) AND \(endValue > startValue ? endValue : startValue)"
    
            featureLayer.featureTable?.queryFeatures(with: queryParams) { multipleResults, error in
                if let error = error {
                    print(error)
                    return
                }
                if let agsfeatures = multipleResults?.featureEnumerator().allObjects {
                    if !agsfeatures.isEmpty {
                        featureLayer.select(agsfeatures)
                        
                        // Create a temp variable to hold our features so that we can perform
                        // all of our operations without triggering a UI update
                        //
                        var temp = self.parent.selectedSegment
                        temp.append(contentsOf: agsfeatures)
                        temp.removeDuplicates()
                        temp.sort { f1, f2 in
                            return f1.attributes[WorkoutRouteAttributes.index.rawValue] as! Int > f2.attributes[WorkoutRouteAttributes.index.rawValue] as! Int
                        }
                        self.parent.selectedSegment = temp
                    }
                }
            }
    
        }
    
        func geoView(_ geoView: AGSGeoView, didTapAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
    
            if let mapView = geoView as? AGSMapView {
    
                mapView.identifyLayers(atScreenPoint: screenPoint, tolerance: 12, returnPopupsOnly: false, maximumResultsPerLayer: 10) { [weak self] (results: [AGSIdentifyLayerResult]?, error: Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    if results?.count == 0 {
                        self?.parent.selectedSegment.removeAll()
                    }
    
                    if let featureCollectionLayer = mapView.map?.operationalLayers.firstObject as? AGSFeatureCollectionLayer, let featureLayer = featureCollectionLayer.layers.first {
                        if let res = results?.first, let feature = res.sublayerResults.first?.geoElements.first as? AGSFeature {
                            self?.selectFeatures(feature: feature, featureLayer: featureLayer)
                        }
                    }
    
                }
            }
        }
    }
}
