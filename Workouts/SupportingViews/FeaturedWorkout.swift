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
        return VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(workout.workoutActivityType.workoutTypeMetadata.activityTypeDescription)
                    .font(.headline)
                    .fontWeight(.semibold)
                Text("\(workout.endDate.date)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding([.top, .leading, .trailing])
            MapView(workout: workout)
                .frame(height: 200)
            Text("test")
        }
        .background(Color.init(.systemGroupedBackground))
        .cornerRadius(12)
        .padding()
    }
}

struct FeaturedWorkout_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedWorkout(workout: HKWorkout(activityType: .running, start: Date(), end: Date()))
    }
}
