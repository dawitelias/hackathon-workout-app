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
        
        workouts.forEach { workout in
            totalCalories += workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0
            totalDistance += workout.totalDistance?.doubleValue(for: .mile()) ?? 0
            totalTime += workout.duration
        }
        
        let workoutTimeString = TimeInterval(exactly: totalTime)?.getHoursAndMinutesString() ?? ""

        return VStack(alignment: .center, spacing: 10) {

            List {

                Section(header: VStack {

                    Text(Strings.quickGlance)
                        .padding(.leading)
                        .frame(width: UIScreen.main.bounds.width, alignment: .leading)

                }, footer: VStack {

                    Text("These statistics are aggregated across the \(workouts.count) workouts you've completed today.")

                }) {

                    // Total Calories Burned
                    //
                    VStack(alignment: .leading, spacing: 5) {

                        Text(Strings.totalCalories)
                            .font(.callout)
                            .foregroundColor(Color.gray)

                        Text("\(String.init(format: "%.0f", totalCalories)) cal")
                            .font(.system(.largeTitle))
                            .fontWeight(.bold)

                    }

                    // Total Duration
                    //
                    VStack(alignment: .leading) {

                        Text(Strings.totalDuration)
                            .font(.callout)
                            .foregroundColor(Color.gray)

                        Text("\(workoutTimeString)")
                            .font(.system(.largeTitle))
                            .fontWeight(.bold)

                    }
                    
                    // Total Distance
                    //
                    VStack(alignment: .leading) {

                        Text(Strings.totalDistance)
                            .font(.callout)
                            .foregroundColor(Color.gray)

                        Text("\(String.init(format: "%.0f", totalDistance)) miles")
                            .font(.system(.largeTitle))
                            .fontWeight(.bold)

                    }

                }

                // List Workouts for the day
                //
                Section(header: VStack {

                    Text(Strings.moreDetail)
                        .padding(.leading)
                        .frame(width: UIScreen.main.bounds.width, alignment: .leading)

                }) {

                    ForEach(workouts, id: \.self) { workout in

                        NavigationLink(destination: WorkoutDetail(viewModel: WorkoutDetailViewModel(workout: workout))) {

                            WorkoutRow(workout: workout)

                        }
                        .padding(.vertical, 8.0)

                    }
                }
            }
            .modifier(GroupedListModifier())
            .navigationBarTitle(Text(Strings.dailySummary))
        }
    }
}

// MARK: Strings and assets
//
extension DailySummary {
    
    private struct Strings {

        public static var dailySummary: String {
            NSLocalizedString("com.okapi.dailySummary.dailySummary", value: "Daily Summary", comment: "Daily Summary text.")
        }
        public static var quickGlance: String {
            NSLocalizedString("com.okapi.dailySummary.quickGlance", value: "Quick Glance", comment: "Quick Glance text.")
        }
        public static var totalCalories: String {
            NSLocalizedString("com.okapi.dailySummary.totalCalories", value: "Total Calories Burned:", comment: "Total calories burned text.")
        }
        public static var totalDuration: String {
            NSLocalizedString("com.okapi.dailySummary.totalDuration", value: "Total Duration", comment: "Total duration string")
        }
        public static var totalDistance: String {
            NSLocalizedString("com.okapi.dailySummary.totalDistance", value: "Total Distance", comment: "Total distance string")
        }
        public static var moreDetail: String {
            NSLocalizedString("com.okapi.dailySummary.moreDetail", value: "More Detail 🏅", comment: "More Detail text")
        }
    }

}

// MARK: Previews
//
struct DailySummary_Previews: PreviewProvider {
    static var previews: some View {
        DailySummary(workouts: [
            HKWorkout(activityType: .running, start: Date(), end: Date()),
            HKWorkout(activityType: .walking, start: Date(), end: Date()),
            HKWorkout(activityType: .yoga, start: Date(), end: Date())
        ])
    }
}
