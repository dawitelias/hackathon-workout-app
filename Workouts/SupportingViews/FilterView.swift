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
    @EnvironmentObject private var userData: UserData

    var workouts = HKWorkoutActivityType.allCases.map { $0.workoutTypeMetadata.activityTypeDescription }
    
    @Binding var showFilterView: Bool
    @State private var selectedWorkouts = 0
    @State private var caloriesBurned = 0
    @State private var querySinceDate = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Workouts", selection: $selectedWorkouts) {
                        ForEach(0 ..< workouts.count) {
                            Text(self.workouts[$0])

                        }
                    }
                }
                
                // Select date you want to show
                //
                Section {
                    DatePicker(selection: $querySinceDate, in: ...(Calendar.current.date(byAdding: .month, value: -12, to: Date()) ?? Date()), displayedComponents: .date) {
                        Text("Select a date")
                    }
                }

                // pick a caloric range.. maybe incremented not by 1, which would be pretty terrible
                Section(header: Text("Calories Burned")) {
                    Picker("From", selection: $caloriesBurned) {
                        ForEach(0 ..< 5000) {
                            Text("\($0) calories")
                        }
                    }
                    Picker("To", selection: $caloriesBurned) {
                        ForEach(0 ..< 5000) {
                            Text("\($0) calories")
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Filters"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.showFilterView = false
                }) {
                    Text("Done").bold()
                })
        }.onAppear {
//            self.selectedWorkouts = self.workouts.firstIndex(of: self.userData.activityTypeFilter.workoutTypeMetadata.activityTypeDescription) ?? 0
        }.onDisappear {
//            self.userData.activityTypeFilter = HKWorkoutActivityType.allCases.filter { return $0.workoutTypeMetadata.activityTypeDescription == self.workouts[self.selectedWorkouts] }.first ?? .walking
            self.userData.queryWorkouts()
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(showFilterView: .constant(false)).environmentObject(UserData())
    }
}
