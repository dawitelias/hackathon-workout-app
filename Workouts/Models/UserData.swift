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
    
    private var healthKitAssistant = HealthKitAssistant()

    init() {
        // TODO: ".walking" -> this is just to go and grab some initial data this will change
        //
        healthKitAssistant.getWorkoutsByType(type: .walking) { [weak self] results, error in
            guard let workouts = results else {
                return
            }
            self?.workouts = workouts
        }
    }
}
