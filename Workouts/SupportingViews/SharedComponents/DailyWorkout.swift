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
        let workoutDistance = workout.totalDistance?.doubleValue(for: .mile()) ?? 0
        let distanceString = "\(String.init(format: "%.2f", workoutDistance))mi"

        return HStack(alignment: .top) {
            ZStack(alignment: .topLeading) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(workout.workoutActivityType.workoutTypeMetadata.activityTypeDescription)
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(workout.workoutActivityType.workoutTypeMetadata.highlightColor)
                        .fixedSize(horizontal: false, vertical: true)

                    Text("\(workoutHrAndMin)")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(Color(UIColor.label))
                    
                    if workout.totalDistance != nil {
                        Text(distanceString)
                            .font(.title)
                            .fontWeight(.heavy)
                            .foregroundColor(Color(UIColor.label))
                    } else if workout.totalEnergyBurned != nil {
                        Text("\(Int(workout.totalEnergyBurned!.doubleValue(for: .kilocalorie()))) cal")
                            .font(.title)
                            .fontWeight(.heavy)
                            .foregroundColor(Color(UIColor.label))
                        
                    }
                    
                }
                .frame(width: 200, height: 180, alignment: .leading)
                .padding(.leading, 20)
                .padding(.top, 10)
                
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
