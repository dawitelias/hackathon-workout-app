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
    
    let color: Color

    var body: some View {

        HStack {

            Icon(image: Image(workout.workoutActivityType.workoutTypeMetadata.systemIconName), mainColor: workout.workoutActivityType.workoutTypeMetadata.mainColor, highlightColor: workout.workoutActivityType.workoutTypeMetadata.highlightColor, size: 35)

            VStack(alignment: .leading) {

                HStack {

                    Text(workout.workoutActivityType.workoutTypeMetadata.activityTypeDescription)
                        .lineLimit(1)
                        .fixedSize(horizontal: false, vertical: true)
                        
                    Text("·")
                        .font(.caption)
                        .foregroundColor(Color.gray)
                        .fixedSize()

                    Text("\(workout.startDate.weekday)")
                        .font(.caption)
                        .foregroundColor(Color.gray)
                        .fixedSize()

                }

                Text("\(workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0, specifier: "%.0f")cal")
                    .font(.system(.largeTitle, design: .rounded))
                    .foregroundColor(color)

            }
            .padding(.leading)
        }
    }
}

struct WorkoutRow_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutRow(workout: HKWorkout(activityType: .running, start: Date(), end: Date()), color: .red)
    }
}
