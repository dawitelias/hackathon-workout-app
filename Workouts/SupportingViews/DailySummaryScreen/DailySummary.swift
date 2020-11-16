//
//  DailySummary.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/29/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI
import HealthKit

struct DailySummary: View {
    var workouts: [HKWorkout]

    var body: some View {
        var totalCalories: Double = 0
        var totalDistance: Double = 0
        var totalTime: Double = 0
        
        _ = workouts.map { workout in
            totalCalories += workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0
            totalDistance += workout.totalDistance?.doubleValue(for: .mile()) ?? 0
            totalTime += workout.duration
        }
        
        let workoutTimeString = TimeInterval(exactly: totalTime)?.getHoursAndMinutesString() ?? ""

        return VStack(alignment: .center, spacing: 10) {
            List {
                Section(header: VStack {
                    Text("Todays Stats:")
                        .padding(.all)
                        .font(.system(size: 21, weight: .medium))
                        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                }, footer: VStack {
                    Text("These statistics are aggregated across the \(workouts.count) workouts you've completed today.")
                }) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Total Calories Burned")
                            .font(.callout)
                            .foregroundColor(Color.gray)
                        Text("\(String.init(format: "%.0f", totalCalories)) cal")
                            .font(.system(.largeTitle))
                            .fontWeight(.bold)
                    }
                    VStack(alignment: .leading) {
                        Text("Total Time:")
                            .font(.callout)
                            .foregroundColor(Color.gray)
                        Text("\(workoutTimeString)")
                            .font(.system(.largeTitle))
                            .fontWeight(.bold)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Total Distance:")
                            .font(.callout)
                            .foregroundColor(Color.gray)
                        Text("\(String.init(format: "%.0f", totalDistance)) miles")
                            .font(.system(.largeTitle))
                            .fontWeight(.bold)
                    }
                }
                Section(header: VStack {
                    Text("More Detail 🏅")
                        .padding(.all)
                        .font(.system(size: 21, weight: .medium))
                        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                }) {
                    ForEach(workouts, id: \.self) { workout in
                        NavigationLink(destination: WorkoutDetail(workout: workout)) {
                            WorkoutRow(workout: workout)
                        }.padding(.vertical, 8.0)
                    }
                }
            }
            .modifier(GroupedListModifier())
            .navigationBarTitle(Text("Daily Summary"))
        }
    }
}

struct DailySummary_Previews: PreviewProvider {
    static var previews: some View {
        DailySummary(workouts: [
            HKWorkout(activityType: .running, start: Date(), end: Date()),
            HKWorkout(activityType: .walking, start: Date(), end: Date()),
            HKWorkout(activityType: .yoga, start: Date(), end: Date())
        ])
    }
}
