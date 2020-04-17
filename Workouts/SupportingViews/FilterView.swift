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
    @State private var caloriesBurnedMin = ""
    @State private var caloriesBurnedMax = ""
    
    // Date range state variables
    //
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    
    // Calorie range sort variables
    //
//    @State private var caloriesBurnedMin: String = "0"
//    @State private var caloriesBurnedMax: String = "1000"
    
    // Distance range sort variables
    //
    @State private var minDistance: Int = 0
    @State private var maxDistance: Int = 100
    
    // Duration range sort variables
    //
    @State private var minDuration: Int = 0
    @State private var maxDuration: Int = 300
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Workout Types", selection: $selectedWorkouts) {
                        ForEach(0 ..< workouts.count) {
                            Text(self.workouts[$0])

                        }
                    }
                }
                
                // Select date you want to show
                //
                Section(header: Text("Filter by Date Range")) {
                    DatePicker(selection: $startDate, in: ...(Calendar.current.date(byAdding: .month, value: -12, to: Date()) ?? Date()), displayedComponents: .date) {
                        Text("Start Date:")
                    }
                    DatePicker(selection: $endDate, in: ...(Calendar.current.date(byAdding: .month, value: 12, to: Date()) ?? Date()), displayedComponents: .date) {
                        Text("End Date:")
                    }
                }
                

                // Select calorie range
                //
                Section(header: Text("Calories Burned")) {
                TextField("From", text: $caloriesBurnedMin)
                    .keyboardType(.numberPad)
                TextField("To", text: $caloriesBurnedMax)
                    .keyboardType(.numberPad)

                }
                
                // Select distance range
                //
                Section(header: Text("Filter by Workout Distance")) {
                    DatePicker(selection: $startDate, in: ...(Calendar.current.date(byAdding: .month, value: -12, to: Date()) ?? Date()), displayedComponents: .date) {
                        Text("Start Date:")
                    }
                    DatePicker(selection: $endDate, in: ...(Calendar.current.date(byAdding: .month, value: 12, to: Date()) ?? Date()), displayedComponents: .date) {
                        Text("End Date:")
                    }
                }
                
                // Select duration range
                //
                Section(header: Text("Filter by Workout Duration")) {
                    DatePicker(selection: $startDate, in: ...(Calendar.current.date(byAdding: .month, value: -12, to: Date()) ?? Date()), displayedComponents: .date) {
                        Text("Start Date:")
                    }
                    DatePicker(selection: $endDate, in: ...(Calendar.current.date(byAdding: .month, value: 12, to: Date()) ?? Date()), displayedComponents: .date) {
                        Text("End Date:")
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
