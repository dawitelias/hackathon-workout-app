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
    @State private var workoutDuration = DurationWorkoutFilter(value: 0, isApplied: false, color: .red)

    var body: some View {
        let durationString = "\(Int(workoutDuration.value/3600)) hr \(Int((workoutDuration.value/3600).truncatingRemainder(dividingBy: 1) * 60)) min"
        
        return VStack {
            List {
                Section(footer: Text("Only show workouts up to the selected duration.")) {
                    ToggleableHeader(text: "Duration", currentValueText: nil, switchValue: $workoutDuration.isApplied)
                    if workoutDuration.isApplied {
                        Stepper(value: $workoutDuration.value, step: 60 * 15) { // 60 seconds * 15 minutes
                            Text(durationString)
                        }
                    }
                }
            }
            .navigationBarTitle("Duration")
            .listStyle(GroupedListStyle()).environment(\.horizontalSizeClass, .regular).frame(width: nil, height: nil, alignment: .top)
        }.onAppear {
            self.workoutDuration = self.workoutData.durationFilter
        }.onDisappear {
            self.workoutData.durationFilter = self.workoutDuration
            self.workoutData.queryWorkouts()
        }
    }
}

struct DurationFilter_Previews: PreviewProvider {
    static var previews: some View {
        DurationFilter().environmentObject(WorkoutData())
    }
}
