//
//  DistanceFilter.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/25/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct DistanceFilter: View {

    @EnvironmentObject var workoutData: WorkoutData

    @State private var workoutDistance = DistanceWorkoutFilter(value: 0, isApplied: false)

    var body: some View {

        VStack {

            List {

                Section(footer: Text(Strings.footerText)) {

                    ToggleableHeader(text: Strings.distanceText, currentValueText: nil, switchValue: $workoutDistance.isApplied)

                    if workoutDistance.isApplied {

                        Stepper(value: $workoutDistance.value) {

                            Text("\(Int(workoutDistance.value)) \(workoutData.settings.userUnitPreferences.abbreviatedDistanceUnit)")

                        }

                    }

                }

            }
            .navigationBarTitle(Strings.distanceText)
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .frame(width: nil, height: nil, alignment: .top)

        }.onAppear {

            workoutDistance = workoutData.distanceFilter

        }.onDisappear {

            workoutData.distanceFilter = workoutDistance
            workoutData.queryWorkouts()

        }
    }
}

// MARK: Strings and assets
//
extension DistanceFilter {

    private struct Strings {

        static var distanceText: String {
            NSLocalizedString("com.okapi.distanceFilter.title", value: "Distance", comment: "Title for the distance filter")
        }

        static var footerText: String {
            NSLocalizedString("com.okapi.distanceFilter.footerText", value: "Only show workouts up to the selected distance.", comment: "Only show workouts up to the selected distance.")
        }
    }

}

// MARK: Previews
//
struct DistanceFilter_Previews: PreviewProvider {
    static var previews: some View {
        DistanceFilter().environmentObject(WorkoutData())
    }
}
