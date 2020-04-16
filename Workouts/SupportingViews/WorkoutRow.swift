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
        HStack {
            Image(systemName: workout.workoutTypeMetadata.systemIconName) // The icons are being determined in HelpersAndExtensions/HKWorkout+Extensions file... you can tell it which icons you want for each activity type in here
            Text(workout.workoutTypeMetadata.activityDescription) // ^^
            Spacer()
            Text(workout.startDate.weekday)
                .font(.caption)
                .foregroundColor(Color.gray)
        }
    }
}

struct WorkoutRow_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutRow(workout: HKWorkout(activityType: .running, start: Date(), end: Date()))
    }
}
