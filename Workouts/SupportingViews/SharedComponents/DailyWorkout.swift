//
//  DailyWorkout.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/25/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI
import HealthKit

struct DailyWorkout: View {
    var workout: HKWorkout

    var body: some View {
        let workoutDistance = workout.totalDistance?.doubleValue(for: .mile()) ?? 0

        let distanceString = "\(String.init(format: "%.0f", workoutDistance)) mile"
        let workoutHrAndMin = workout.duration.getHoursAndMinutesString()

        return HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(workout.workoutActivityType.workoutTypeMetadata.activityTypeDescription)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(workout.workoutActivityType.workoutTypeMetadata.highlightColor)

                Text("\(workoutHrAndMin)")
                    .font(.headline)
                    .foregroundColor(Color(UIColor.label))
                
                if workout.totalEnergyBurned != nil {
                    Text("\(workout.totalEnergyBurned!.doubleValue(for: .kilocalorie())) cal")
                        .font(.headline)
                        .foregroundColor(Color(UIColor.label))
                    
                }
                
                
            }
            .padding()
            .frame(width: 200, height: nil, alignment: .center)
        }
        .background(LinearGradient(
            gradient: .init(colors: [workout.workoutActivityType.workoutTypeMetadata.mainColor, workout.workoutActivityType.workoutTypeMetadata.highlightColor]),
            startPoint: .init(x: 0.0, y: 0.0),
            endPoint: .init(x: 0.1, y: 1)
        ))
        .cornerRadius(5)
    }
}

struct DailyWorkout_Previews: PreviewProvider {
    static var previews: some View {
        DailyWorkout(workout: HKWorkout(activityType: .running, start: Date(), end: Date()))
    }
}
