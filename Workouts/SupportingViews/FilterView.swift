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
                Section(header: Text("Calories Burned")) {
                    TextField("From", text: $caloriesBurnedMin)
                        .keyboardType(.numberPad)
                    TextField("To", text: $caloriesBurnedMax)
                        .keyboardType(.numberPad)
                }
            }
            .navigationBarTitle(Text("Filters"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.showFilterView = false
                }) {
                    Text("Done").bold()
                })
        }.onAppear {
            self.selectedWorkouts = self.workouts.firstIndex(of: self.userData.activityTypeFilter.workoutTypeMetadata.activityTypeDescription) ?? 0
        }.onDisappear {
            self.userData.activityTypeFilter = HKWorkoutActivityType.allCases.filter { return $0.workoutTypeMetadata.activityTypeDescription == self.workouts[self.selectedWorkouts] }.first ?? .walking
            self.userData.queryWorkouts()
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(showFilterView: .constant(false)).environmentObject(UserData())
    }
}
