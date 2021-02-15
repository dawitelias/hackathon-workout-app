//
//  CaloriesFilter.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/25/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct CaloriesFilter: View {

    @EnvironmentObject var workoutData: WorkoutData

    @State private var caloriesFilter = CaloriesWorkoutFilter(value: 0, isApplied: false)

    private var caloriesString: String {
        "\(Int(caloriesFilter.value)) cal"
    }

    var body: some View {

        VStack {

            List {

                Section(footer: Text(Strings.footerText)) {

                    ToggleableHeader(text: Strings.caloriesBurnedText, currentValueText: nil, switchValue: $caloriesFilter.isApplied)

                    if caloriesFilter.isApplied {

                        Stepper(value: $caloriesFilter.value, step: caloriesStepAmount) {

                            Text(caloriesString)

                        }

                    }

                }

            }
            .navigationBarTitle(Strings.caloriesBurnedText)
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .frame(width: nil, height: nil, alignment: .top)

        }.onAppear {

            caloriesFilter = workoutData.calorieFilter

        }.onDisappear {

            workoutData.calorieFilter = caloriesFilter
            workoutData.queryWorkouts()

        }
    }

    private let caloriesStepAmount: Double = 50
}

// MARK: Strings and Assets
//
extension CaloriesFilter {

    private struct Strings {

        static var caloriesBurnedText: String {
            NSLocalizedString("com.okapi.caloriesFilter.caloriesBurnedText", value: "Calories Burned", comment: "Calories burned text.")
        }

        static var footerText: String {
            NSLocalizedString("com.okapi.caloriesFilter.footerText", value: "Only show workouts up to the selected number of calories burned.", comment: "Only show workouts up to the selected number of calories burned.")
        }

    }

}

// MARK: Previews
//
struct CaloriesFilter_Previews: PreviewProvider {
    static var previews: some View {
        CaloriesFilter().environmentObject(WorkoutData())
    }
}
