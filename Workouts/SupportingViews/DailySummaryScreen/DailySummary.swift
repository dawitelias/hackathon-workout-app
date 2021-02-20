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

    @EnvironmentObject var workoutData: WorkoutData

    @ObservedObject var viewModel: DailySummaryViewModel
    
    init(workoutData: WorkoutData) {
        viewModel = DailySummaryViewModel(workoutData: workoutData)
    }

    var body: some View {

        NavigationView {

            VStack(alignment: .center, spacing: 10) {

                List {

                    Section(header: VStack {

                        Text(Strings.quickGlance)
                            .padding(.leading)
                            .frame(width: UIScreen.main.bounds.width, alignment: .leading)

                    }, footer: VStack {

                        Text("These statistics are aggregated across the \(viewModel.todaysWorkouts.count) workouts you've completed today.")

                    }) {

                        // Total Calories Burned
                        //
                        VStack(alignment: .leading, spacing: 5) {

                            Text(Strings.totalCalories)
                                .font(.callout)
                                .foregroundColor(Color.gray)

                            Text("\(String.init(format: "%.0f", viewModel.totalCalories)) cal")
                                .font(.system(.largeTitle))
                                .fontWeight(.bold)

                        }

                        // Total Duration
                        //
                        VStack(alignment: .leading) {

                            Text(Strings.totalDuration)
                                .font(.callout)
                                .foregroundColor(Color.gray)

                            Text(viewModel.timerString)
                                .font(.system(.largeTitle))
                                .fontWeight(.bold)

                        }
                        
                        // Total Distance
                        //
                        VStack(alignment: .leading) {

                            Text(Strings.totalDistance)
                                .font(.callout)
                                .foregroundColor(Color.gray)

                            Text("\(String.init(format: "%.0f", viewModel.totalDistance)) \(workoutData.settings.userUnitPreferences.distanceUnit)")
                                .font(.system(.largeTitle))
                                .fontWeight(.bold)

                        }

                    }

                    // Show a list of the workouts that the user has completed today
                    //
                    if viewModel.todaysWorkouts.count > 0 {
                        // List Workouts for the day
                        //
                        Section(header: VStack {

                            Text(Strings.moreDetail)
                                .padding(.leading)
                                .frame(width: UIScreen.main.bounds.width, alignment: .leading)

                        }) {

                            ForEach(viewModel.todaysWorkouts, id: \.self) { workout in

                                NavigationLink(destination: WorkoutDetail(viewModel: WorkoutDetailViewModel(workout: workout, settings: workoutData.settings))) {

                                    WorkoutRow(workout: workout, color: workoutData.settings.themeColor.color)

                                }
                                .padding(.vertical, 8.0)

                            }
                        }
                    } else {

                        Section {

                            ChartDataFailLoad(text: Strings.noData, height: 200, showQuote: false)

                        }

                    }
                    
                }
                .modifier(GroupedListModifier())
                .navigationBarTitle(Text(Strings.dailySummary), displayMode: .large)
            }

        }
    }
}

// MARK: Strings and assets
//
extension DailySummary {
    
    private struct Strings {

        public static var noData: String {
            NSLocalizedString("com.okapi.dailySummary.noData", value: "We can't seem to find any data for today 🤔... \n\n Better get crackin!", comment: "Text for no data today.")
        }
        public static var dailySummary: String {
            NSLocalizedString("com.okapi.dailySummary.dailySummary", value: "Daily Summary", comment: "Daily Summary text.")
        }
        public static var quickGlance: String {
            NSLocalizedString("com.okapi.dailySummary.quickGlance", value: "Quick Glance", comment: "Quick Glance text.")
        }
        public static var totalCalories: String {
            NSLocalizedString("com.okapi.dailySummary.totalCalories", value: "Total Active Calories Burned", comment: "Total calories burned text.")
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

