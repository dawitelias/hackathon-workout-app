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
    
    private var healthKitAssistant = HealthKitAssistant()

    init() {
        // TODO: ".walking" -> this is just to go and grab some initial data this will change
        //
        healthKitAssistant.getWorkoutsByType(type: .walking) { [weak self] results, error in
            guard let workouts = results else {
                return
            }
            self?.workouts = workouts
            self?.groupWorkouts(workouts: workouts)
        }
    }
    
    private func groupWorkouts(workouts: [HKWorkout]) {
        self.workoutsGroupedByDate = Dictionary(grouping: workouts, by: { ("\($0.startDate.month) \($0.startDate.year)") })
        print("Finished grouping workouts: \(self.workoutsGroupedByDate.count)")
    }
}
