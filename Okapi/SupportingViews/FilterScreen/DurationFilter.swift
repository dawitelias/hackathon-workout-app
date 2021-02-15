//
//  DurationFilter.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/25/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct DurationFilter: View {

    @EnvironmentObject var workoutData: WorkoutData

    @State private var workoutDuration = DurationWorkoutFilter(value: 0, isApplied: false)

    var durationString: String {
        "\(Int(workoutDuration.value/3600)) hr \(Int((workoutDuration.value/3600).truncatingRemainder(dividingBy: 1) * 60)) min"
    }

    var body: some View {

        VStack {

            List {

                Section(footer: Text(Strings.footerText)) {

                    ToggleableHeader(text: Strings.durationText, currentValueText: nil, switchValue: $workoutDuration.isApplied)

                    if workoutDuration.isApplied {

                        Stepper(value: $workoutDuration.value, step: fifteenMinutes) {

                            Text(durationString)

                        }

                    }

                }

            }
            .navigationBarTitle(Strings.durationText)
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .frame(width: nil, height: nil, alignment: .top)

        }.onAppear {

            workoutDuration = workoutData.durationFilter

        }.onDisappear {

            workoutData.durationFilter = workoutDuration
            workoutData.queryWorkouts()

        }
    }

    private let fifteenMinutes: Double = 15 * 60 // 60 seconds * 15 minutes
}

// MARK: Strings and assets
//
extension DurationFilter {

    private struct Strings {

        static var durationText: String {
            NSLocalizedString("com.okapi.durationPage.title", value: "Duration", comment: "Title of the duration filter page.")
        }

        static var footerText: String {
            NSLocalizedString("com.okapi.durationPage.footer", value: "Only show workouts up to the selected duration.", comment: "Only show workouts up to the selected duration.")
        }
    }
}

// MARK: Previews
//
struct DurationFilter_Previews: PreviewProvider {
    static var previews: some View {
        DurationFilter().environmentObject(WorkoutData())
    }
}
