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
    @State private var workoutDistance = DistanceWorkoutFilter(value: 0, isApplied: false, color: .blue)

    var body: some View {
        return VStack {
            List {
                Section(footer: Text("Only show workouts up to the selected distance.")) {
                    ToggleableHeader(text: "Distance", currentValueText: nil, switchValue: $workoutDistance.isApplied)
                    if workoutDistance.isApplied {
                        Stepper(value: $workoutDistance.value) {
                            Text("\(Int(workoutDistance.value)) mi")
                        }
                    }
                }
            }
            .navigationBarTitle("Distance")
            .listStyle(GroupedListStyle()).environment(\.horizontalSizeClass, .regular).frame(width: nil, height: nil, alignment: .top)
        }.onAppear {
            self.workoutDistance = self.workoutData.distanceFilter
        }.onDisappear {
            self.workoutData.distanceFilter = self.workoutDistance
            self.workoutData.queryWorkouts()
        }
    }
}

struct DistanceFilter_Previews: PreviewProvider {
    static var previews: some View {
        DistanceFilter().environmentObject(WorkoutData())
    }
}
