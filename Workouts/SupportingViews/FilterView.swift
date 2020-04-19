//
//  FilterView.swift
//  Workouts
//
//  Created by Dawit Elias on 4/15/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI
import HealthKit

struct FilterView: View {
    @EnvironmentObject private var workoutData: WorkoutData

    var workouts = HKWorkoutActivityType.allCases.map { $0.workoutTypeMetadata.activityTypeDescription }
    
    @Binding var showFilterView: Bool
    @State private var selectedWorkouts = 0 // <-- this should be an array when we can select multiple
    
    // State variables
    //
    @State private var dateRangeFilter = DateRangeWorkoutFilter(startDate: Date(), endDate: Date(), isApplied: false)
    @State private var caloriesBurned = CaloriesWorkoutFilter(value: 500, isApplied: false)
    @State private var workoutDistance = DistanceWorkoutFilter(value: 5, isApplied: false)
    @State private var workoutDuration = DurationWorkoutFilter(value: 2, isApplied: false)
    
    var body: some View {
        let durationString = "\(Int(workoutDuration.value/3600)) hr \(Int(workoutDuration.value.truncatingRemainder(dividingBy: 1) * 60)) min"
        let distanceString = "\(String.init(format: "%.2f", workoutDistance.value)) miles"
        let caloriesString = "\(Int(caloriesBurned.value)) calories"

        return NavigationView {
            Form {
                // Workout types is kind of a required filter, since we have to query by activity type
                // so, that's why I didn't wrap this guy in a hidable filter option
                //
                Section {
                    Picker("Workout Types", selection: $selectedWorkouts) {
                        ForEach(0 ..< workouts.count) {
                            Text(self.workouts[$0])

                        }
                    }
                }
                
                // Select date you want to show
                //
                Section(header: ToggleableHeader(text: "Date 📅", switchValue: $dateRangeFilter.isApplied)) {
                    if dateRangeFilter.isApplied {
                        DatePicker(selection: $dateRangeFilter.startDate, in: ...(Calendar.current.date(byAdding: .month, value: 12, to: Date()) ?? Date()), displayedComponents: .date) {
                            Text("From")
                        }
                        DatePicker(selection: $dateRangeFilter.endDate, in: ...(Calendar.current.date(byAdding: .month, value: 12, to: Date()) ?? Date()), displayedComponents: .date) {
                            Text("To")
                        }
                    }
                }
                
                // Select distance range
                //
                // maybe this is conditionally visible based on certain types of workouts (e.g., runs, swims, bike rides, etc.)
                Section(header: ToggleableHeader(text: "Workout Distance (miles) 📏 \(workoutDistance.isApplied ? distanceString : "")", switchValue: $workoutDistance.isApplied)) {
                    if workoutDistance.isApplied {
                        Slider(value: $workoutDistance.value, in: 0...50)
                            .transition(.slide)
                    }
                }
                
                // Select duration
                // Would be nice to use a countdown timer (UIDatePicker.Mode.countDownTimer)
                // But it's not available in SwiftUI yet, how about a slider?
                Section(header: ToggleableHeader(text: "Workout Duration ⏳ \(workoutDuration.isApplied ? durationString : "")", switchValue: $workoutDuration.isApplied)) {
                    if workoutDuration.isApplied {
                        Slider(value: $workoutDuration.value, in: 0...18000)
                            .transition(.slide)
                    }
                }

                
                // Select calorie range
                //
                Section(header: ToggleableHeader(text: "Calories Burned 🥵 \(caloriesBurned.isApplied ? caloriesString : "")", switchValue: $caloriesBurned.isApplied)) {
                    if caloriesBurned.isApplied {
                        Slider(value: $caloriesBurned.value, in: 0...2000)
                            .transition(.asymmetric(insertion: .move(edge: .leading), removal: .slide))
                    }
                }

                // Button that turns off all off the filters
                //
                Button(action: {
                    self.caloriesBurned.isApplied = false
                    self.workoutDistance.isApplied = false
                    self.workoutDuration.isApplied = false
                    self.dateRangeFilter.isApplied = false
                }) {
                    Text("Clear all filters")
                }
            }
            .navigationBarTitle(Text("Filters"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.showFilterView = false
                }) {
                    Text("Done").bold()
                })
        }.onAppear {
            self.dateRangeFilter = self.workoutData.dateRangeFilter
            self.workoutDuration = self.workoutData.durationFilter
            self.caloriesBurned = self.workoutData.calorieFilter
            self.workoutDistance = self.workoutData.distanceFilter
        }.onDisappear {
            self.workoutData.dateRangeFilter = self.dateRangeFilter
            self.workoutData.distanceFilter = self.workoutDistance
            self.workoutData.calorieFilter = self.caloriesBurned
            self.workoutData.durationFilter = self.workoutDuration
            
            // i don't like updating these filters like this, i would
            // much rather bind to the filters that I am setting in the workout
            // data environment object, but not sure how to reconcile that with
            // needing it for the state of this object. Come back to this
            // after I do research.
            
            self.workoutData.queryWorkouts()
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(showFilterView: .constant(false)).environmentObject(WorkoutData())
    }
}
