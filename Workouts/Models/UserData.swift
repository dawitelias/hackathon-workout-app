//
//  UserData.swift
//  HealthKitSwiftUI
//
//  Created by Emily Cheroske on 4/13/20.
//  Copyright © 2020 Emily Cheroske. All rights reserved.
//

import Foundation
import HealthKit

class UserData: ObservableObject {

    @Published var workouts: [HKWorkout] = [HKWorkout]()
    @Published var workoutsGroupedByDate: [String: [HKWorkout]] = [String: [HKWorkout]]()
    
    // Add in whatever activity types you want to see here, I just added default, if we can select multiple from the picker we can update this to hold array
    //
    @Published var activityTypeFilter: HKWorkoutActivityType = .walking
    
    private var healthKitAssistant = HealthKitAssistant()

    init() {
        queryWorkouts()
    }
    
    func queryWorkouts() {
        healthKitAssistant.getWorkoutsByType(type: activityTypeFilter) { [weak self] results, error in
            guard let workouts = results else {
                return
            }
            self?.workouts = workouts
            self?.groupWorkouts(workouts: workouts)
        }
    }

    private func groupWorkouts(workouts: [HKWorkout]) {
        self.workoutsGroupedByDate = Dictionary(grouping: workouts, by: { ("\($0.startDate.month) \($0.startDate.year)") })
    }
}
