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
    
    var workouts = ["Strength Training", "Yoga", "Outdoor Run", "Outdoor Cycle", "Etc....."]
    
    @Binding var showFilterView: Bool
    @State private var selectedWorkouts = 0
    @State private var caloriesBurned = 0
    
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
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(showFilterView: .constant(false))
    }
}
