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
    let exerciseGreen = UIColor(red: 0.655, green: 0.992, blue: 0.2, alpha: 1)

    var body: some View {
        HStack {
            Image(systemName: workout.workoutActivityType.workoutTypeMetadata.systemIconName)
            VStack(alignment: .leading) {
                HStack {
                    Text(workout.workoutActivityType.workoutTypeMetadata.activityTypeDescription) // ^^
                    Text("·   " + workout.startDate.weekday)
                    .font(.caption)
                    .foregroundColor(Color.gray)
                }
                Text("\(workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0, specifier: "%.0f")cal")
                    .font(.largeTitle)
                    .foregroundColor(Color.init(exerciseGreen))
            }
        }
    }
}

struct WorkoutRow_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutRow(workout: HKWorkout(activityType: .running, start: Date(), end: Date()))
    }
}
