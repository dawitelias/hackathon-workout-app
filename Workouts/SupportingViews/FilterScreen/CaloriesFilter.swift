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
    @State private var caloriesFilter = CaloriesWorkoutFilter(value: 0, isApplied: false, color: .red)

    var body: some View {
        let caloriesString = "\(Int(caloriesFilter.value)) cal"

        return VStack {
            List {
                Section(footer: Text("Only show workouts up to the selected number of calories burned.")) {
                    ToggleableHeader(text: "Calories Burned", currentValueText: nil, switchValue: $caloriesFilter.isApplied)
                    if caloriesFilter.isApplied {
                        Stepper(value: $caloriesFilter.value, step: 50) {
                            Text(caloriesString)
                        }
                    }
                }
            }
            .navigationBarTitle("Calories Burned")
            .listStyle(GroupedListStyle()).environment(\.horizontalSizeClass, .regular).frame(width: nil, height: nil, alignment: .top)
        }.onAppear {
            self.caloriesFilter = self.workoutData.calorieFilter
        }.onDisappear {
            self.workoutData.calorieFilter = self.caloriesFilter
            self.workoutData.queryWorkouts()
        }
    }
}

struct CaloriesFilter_Previews: PreviewProvider {
    static var previews: some View {
        CaloriesFilter().environmentObject(WorkoutData())
    }
}
