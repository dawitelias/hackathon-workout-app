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

struct EsriMapView: UIViewRepresentable {
    
    @EnvironmentObject var viewModel: FullScreenMapViewModel

    @Environment(\.colorScheme) var colorScheme

    @Binding var mapView: AGSMapView
    
    var isUserInteractionEnabled: Bool = false

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> AGSMapView {
    
        mapView.isAttributionTextVisible = false
        mapView.touchDelegate = context.coordinator
        mapView.selectionProperties.color = .cyan

        let map = AGSMap(basemap: colorScheme == .dark ? AGSBasemap.darkGrayCanvasVector() : AGSBasemap.lightGrayCanvasVector())

        mapView.map = map
        mapView.isUserInteractionEnabled = isUserInteractionEnabled

        drawRoute(uiView: mapView)

        return mapView
    }

    func updateUIView(_ uiView: AGSMapView, context: Context) {
        if viewModel.selectedSegment.count <= 0 {
            if let featureCollectionLayer = uiView.map?.operationalLayers.firstObject as? AGSFeatureCollectionLayer, let featureLayer = featureCollectionLayer.layers.first {
                featureLayer.clearSelection()
            }
        }
        if lightOrDark != nil && lightOrDark != colorScheme {

            lightOrDark = colorScheme
    
            let basemap = colorScheme == .dark ? AGSBasemap.darkGrayCanvasVector() : AGSBasemap.lightGrayCanvasVector()

            uiView.map?.basemap = basemap
            uiView.reloadInputViews()

        }

    }
    
    private func drawRoute(uiView: AGSMapView) {
        guard let maxVelocity = viewModel.route?.max(by: { return $0.speed < $1.speed })?.speed, let minVelocity = viewModel.route?.min(by: { return $0.speed < $1.speed })?.speed else {
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
        if let workoutRoute = viewModel.route {
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
        if let firstPoint = viewModel.route?.first?.coordinate, let lastPoint = viewModel.route?.last?.coordinate {
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
        if let workoutRoute = viewModel.route, let max = workoutRoute.map({ return $0.speed }).max() {
            maxValue = max
        }
        let colors: [UIColor] = [
            UIColor(named:"GC_12")!,
            UIColor(named:"GC_11")!,
            UIColor(named:"GC_10")!,
            UIColor(named:"GC_9")!,
            UIColor(named:"GC_8")!,
            UIColor(named:"GC_7")!,
            UIColor(named:"GC_6")!,
            UIColor(named:"GC_5")!,
            UIColor(named:"GC_4")!,
            UIColor(named:"GC_3")!,
            UIColor(named:"GC_2")!,
            UIColor(named:"GC_1")!
        ]
        var classBreaks = [AGSClassBreak]()
        let incrementAmount = (maxValue - minValue) / Double(colors.count)
        for i in 0...colors.count - 1 {
            classBreaks.append(AGSClassBreak(description: "\(i)", label: "\(i)", minValue: incrementAmount * Double(i), maxValue: (incrementAmount * Double(i)) + incrementAmount, symbol: AGSSimpleMarkerSymbol(style: .circle, color: colors[i], size: 5)))
        }

        let renderer = AGSClassBreaksRenderer(fieldName: WorkoutRouteAttributes.speed.rawValue, classBreaks: classBreaks)
        pointsCollectionTable.renderer = renderer
        
        // Create a new point feature, provide geometry and attribute values
        if var workoutRoute = viewModel.route {
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
            if parent.viewModel.selectedSegment.count == 0 {
                parent.viewModel.selectedSegment.append(feature)
                featureLayer.select(feature)
                return
            }
    
            // We can assume the user has already defined a starting point for the segment - now we can
            // continue with the logic to highlight/select wherever else they tap
            //
            let startValue = parent.viewModel.selectedSegment[Int(parent.viewModel.selectedSegment.count/2)].attributes[WorkoutRouteAttributes.index.rawValue] as! Int
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
                        var temp = self.parent.viewModel.selectedSegment
                        temp.append(contentsOf: agsfeatures)
                        temp.removeDuplicates()
                        temp.sort { f1, f2 in
                            return f1.attributes[WorkoutRouteAttributes.index.rawValue] as! Int > f2.attributes[WorkoutRouteAttributes.index.rawValue] as! Int
                        }
                        self.parent.viewModel.selectedSegment = temp
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
                        self?.parent.viewModel.selectedSegment.removeAll()
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
