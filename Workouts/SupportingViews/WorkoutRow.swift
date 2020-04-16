//
//  WorkoutRow.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/15/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI
import HealthKit

struct WorkoutRow: View {
    var workout: HKWorkout

    var body: some View {
        NavigationLink(destination: Text("hi there")) {
        // existing contents…
        // NavigationLink(destination: ItemDetail(item: item))
            HStack {
                Image(systemName: workout.workoutTypeMetadata.systemIconName)
                Text(workout.workoutTypeMetadata.activityDescription)
                Spacer()
                Text(workout.startDate.weekday)
                    .font(.caption)
                    .foregroundColor(Color.gray)
            }
        }
    }
}

struct WorkoutRow_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutRow(workout: HKWorkout(activityType: .running, start: Date(), end: Date()))
    }
}
