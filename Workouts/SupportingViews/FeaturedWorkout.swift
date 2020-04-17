//
//  FeaturedWorkout.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/16/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI
import HealthKit

struct FeaturedWorkout: View {
    var workout: HKWorkout

    var body: some View {
        MapView(workout: workout)
    }
}

struct FeaturedWorkout_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedWorkout(workout: HKWorkout(activityType: .running, start: Date(), end: Date()))
    }
}
