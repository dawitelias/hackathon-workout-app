//
//  WorkoutDetail.swift
//  HealthKitSwiftUI
//
//  Created by Emily Cheroske on 4/15/20.
//  Copyright © 2020 Emily Cheroske. All rights reserved.
//

import SwiftUI
import HealthKit
import CoreLocation

struct WorkoutDetail: View {
    let workout: HKWorkout

    var body: some View {
        VStack {
            MapView(workout: workout)
        }
    }
}

struct WorkoutDetail_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutDetail(workout: HKWorkout(activityType: .running, start: Date(), end: Date()))
    }
}
