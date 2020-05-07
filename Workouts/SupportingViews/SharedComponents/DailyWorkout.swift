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
        let workoutHrAndMin = workout.duration.getHoursAndMinutesString()

        return HStack {
            ZStack(alignment: .topLeading) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(workout.workoutActivityType.workoutTypeMetadata.activityTypeDescription)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(workout.workoutActivityType.workoutTypeMetadata.highlightColor)
                        .fixedSize()

                    Text("\(workoutHrAndMin)")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(Color(UIColor.label))
                    
                    if workout.totalEnergyBurned != nil {
                        Text("\(Int(workout.totalEnergyBurned!.doubleValue(for: .kilocalorie()))) cal")
                            .font(.title)
                            .fontWeight(.heavy)
                            .foregroundColor(Color(UIColor.label))
                        
                    }
                    
                    
                }
                .frame(width: 200, height: nil, alignment: .leading)
                .padding(.leading, 20)
                .padding(.top, 20)
                
                VStack(alignment: .trailing, spacing: nil) {
                    Image(workout.workoutActivityType.workoutTypeMetadata.systemIconName)
                        .foregroundColor(workout.workoutActivityType.workoutTypeMetadata.highlightColor)
                        .opacity(0.2)
                }.offset(x: 70, y: 0)
            }
            
        }
        .background(Color(UIColor.tertiarySystemFill))
        .cornerRadius(5)
    }
}

struct DailyWorkout_Previews: PreviewProvider {
    static var previews: some View {
        DailyWorkout(workout: HKWorkout(activityType: .running, start: Date(), end: Date()))
    }
}
