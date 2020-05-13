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

var generatedSharedMapImage: UIImage = UIImage()

struct FullScreenMapView: View {
    let workout: HKWorkout
    @State var showShareSheet: Bool = false
    
    var body: some View {
        VStack {
            MapView(workout: workout, isUserInteractionEnabled: true)
        }
        .edgesIgnoringSafeArea(.vertical)
        .navigationBarItems(trailing:
            Button(action: {
                if self.showShareSheet == false {
                    self.workout.getWorkoutLocationData { route, error in
                        guard let workoutRoute = route else {
                            return
                        }
                        MapImageGenerator.generateMapImageWithRoute(route: workoutRoute) {
                            image, error in
                            guard let generatedImage = image else {
                                return
                            }
                            generatedMapImage = generatedImage
                            self.showShareSheet.toggle()
                        }
                    }
                } else {
                    self.showShareSheet.toggle()
                }
            }) {
                Image(systemName: "square.and.arrow.up").imageScale(.large)
            }.sheet(isPresented: $showShareSheet) {
                ShareSheet(activityItems: [generatedSharedMapImage])
            }
        )
    }
}

struct FullScreenMapView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenMapView(workout: HKWorkout(activityType: .running, start: Date(), end: Date()))
    }
}
