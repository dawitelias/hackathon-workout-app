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

struct EsriMapView: UIViewRepresentable {
    
    var route: [CLLocation]?
    var isUserInteractionEnabled: Bool = false

    let darkBasemapURL = "https://emilcheroske.maps.arcgis.com/home/item.html?id=6f4816759ad34e66b2b5a1c15e51f8e0"
    let lightBasemapURL = "https://emilcheroske.maps.arcgis.com/home/item.html?id=1becad86ac93425eb3fd2343e4507359"

    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedSegment: [AGSFeature]

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> AGSMapView {
        let mapView = AGSMapView(frame: .zero)
        mapView.isAttributionTextVisible = false
        mapView.touchDelegate = context.coordinator
        mapView.selectionProperties.color = .cyan

        lightOrDark = colorScheme
        if let url = colorScheme == .dark ? URL(string: darkBasemapURL) : URL(string: lightBasemapURL) {
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
            if let url = colorScheme == .dark ? URL(string: darkBasemapURL) : URL(string: lightBasemapURL) {
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
        let speedField = AGSField(fieldType: .double, name: "Speed", alias: "Speed", length: 100, domain: nil, editable: true, allowNull: true)
        let elevationField = AGSField(fieldType: .double, name: "Elevation", alias: "Elevation", length: 100, domain: nil, editable: true, allowNull: true)
        let timestamp = AGSField(fieldType: .date, name: "Timestamp", alias: "Timestamp", length: 100, domain: nil, editable: true, allowNull: true)
        let indexField = AGSField(fieldType: .int32, name: "PointIndex", alias: "PointIndex", length: 100, domain: nil, editable: true, allowNull: false)
        
        fields.append(speedField)
        fields.append(elevationField)
        fields.append(timestamp)
        fields.append(indexField)

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

        let renderer = AGSClassBreaksRenderer(fieldName: "Speed", classBreaks: classBreaks)
        pointsCollectionTable.renderer = renderer
        
        // Create a new point feature, provide geometry and attribute values
        if var workoutRoute = route {
            workoutRoute = workoutRoute.filter { item in
                return item.horizontalAccuracy > 0 && item.coordinate.latitude != 0 && item.coordinate.longitude != 0
            }
            let density = Double(workoutRoute.count)/2000.0 // ? may  need to up this if memory is an issue
            let stepCount = density < 1 ? 1 : Int(density)
            
            for index in stride(from: 0, to: workoutRoute.count - stepCount, by: stepCount) {
                let pointFeature = pointsCollectionTable.createFeature()
                let point = AGSPoint(clLocationCoordinate2D: workoutRoute[index].coordinate)
                pointFeature.geometry = point
                pointFeature.attributes["Elevation"] = workoutRoute[index].altitude
                pointFeature.attributes["Speed"] = workoutRoute[index].speed
                //pointFeature.attributes["Course"] = workoutRoute[index].course
                pointFeature.attributes["PointIndex"] = index
                pointFeature.attributes["Timestamp"] = workoutRoute[index].timestamp
                pointsCollectionTable.add(pointFeature, completion: nil)
            }
        }

        return pointsCollectionTable
    }
    // MARK: Coordinator
    //
    class Coordinator: NSObject, AGSGeoViewTouchDelegate {
        var parent: EsriMapView

        init(_ pageViewController: EsriMapView) {
            self.parent = pageViewController
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
            let startValue = parent.selectedSegment[Int(parent.selectedSegment.count/2)].attributes["PointIndex"] as! Int
            let endValue = feature.attributes["PointIndex"] as! Int
    
            let queryParams = AGSQueryParameters()
            queryParams.whereClause = "PointIndex BETWEEN \(startValue < endValue ? startValue : endValue) AND \(endValue > startValue ? endValue : startValue)"
    
            featureLayer.featureTable?.queryFeatures(with: queryParams) { multipleResults, error in
                if let error = error {
                    print(error)
                    return
                }
                if let agsfeatures = multipleResults?.featureEnumerator().allObjects {
                    if !agsfeatures.isEmpty {
                        featureLayer.select(agsfeatures)
                        self.parent.selectedSegment.append(contentsOf: agsfeatures)
                    }
                }
            }
    
        }
    
        func geoView(_ geoView: AGSGeoView, didTapAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
    
            if let mapView = geoView as? AGSMapView {
    
                mapView.identifyLayers(atScreenPoint: screenPoint, tolerance: 12, returnPopupsOnly: false, maximumResultsPerLayer: 10) { (results: [AGSIdentifyLayerResult]?, error: Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
    
                    if let featureCollectionLayer = mapView.map?.operationalLayers.firstObject as? AGSFeatureCollectionLayer, let featureLayer = featureCollectionLayer.layers.first {
                        if let res = results?.first, let feature = res.sublayerResults.first?.geoElements.first as? AGSFeature {
                            self.selectFeatures(feature: feature, featureLayer: featureLayer)
                        }
                    }
    
                }
            }
        }
    }
}

struct EsriMapView_Previews: PreviewProvider {
    static var previews: some View {
        EsriMapView(route: [
            CLLocation(latitude: 70.2568, longitude: 43.6591),
            CLLocation(latitude: 70.2578, longitude: 43.65978),
            CLLocation(latitude: 70.2548, longitude: 43.6548),
            CLLocation(latitude: 70.2538, longitude: 43.6538),
        ], isUserInteractionEnabled: true, selectedSegment: .constant([AGSFeature]()))
            .previewDevice("iPhone 11")
    }
}
