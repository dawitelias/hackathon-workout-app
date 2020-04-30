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
            VStack {
                Image(workout.workoutActivityType.workoutTypeMetadata.systemIconName)
                    .resizable()
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color(UIColor.systemFill), lineWidth: 10))
                    .padding(.top, 10)
                    .padding(.trailing, 5)
                    .padding(.leading, 5)
                    .padding(.bottom, 10)
            }
            .padding(.top, 10)
            .padding(.bottom, 10)
            .padding(.leading, 10)

            VStack(alignment: .leading, spacing: 5) {
                Text(workout.workoutActivityType.workoutTypeMetadata.activityTypeDescription)
                    .font(.callout)
                    .fontWeight(.thin)
                    .foregroundColor(Color.gray)
                    .fixedSize()

                Text("\(distanceString)")
                    .font(.callout)

                Text("\(workoutHrAndMin)")
                    .font(.callout)
            }
            .padding(.top, 10)
            .padding(.bottom, 10)
            .padding(.trailing, 30)
        }
        .background(Color(UIColor.systemFill))
        .cornerRadius(5)
    }
}

struct DailyWorkout_Previews: PreviewProvider {
    static var previews: some View {
        DailyWorkout(workout: HKWorkout(activityType: .running, start: Date(), end: Date()))
    }
}
