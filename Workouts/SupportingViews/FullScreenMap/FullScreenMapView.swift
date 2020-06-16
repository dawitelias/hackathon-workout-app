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

struct FullScreenMapView: View {
    let route: [CLLocation]
    @State var showShareSheet: Bool = false
    
    var body: some View {
        
        return VStack {
            EsriMapView(route: route, isUserInteractionEnabled: true)
        }
        .edgesIgnoringSafeArea(.vertical)
        .navigationBarItems(trailing:
            Button(action: {
                if self.showShareSheet == false {
                    MapImageGenerator.generateMapImageWithRoute(route: self.route) {
                        image, error in
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
                "\(ChuckNorris.getRandomChuckNorrisQuote())"])
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
        ])
    }
}
