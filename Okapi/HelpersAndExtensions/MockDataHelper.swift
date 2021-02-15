//
//  MockDataHelper.swift
//  Workouts
//
//  Created by Emily Cheroske on 6/22/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import Foundation
import HealthKit

class MockDataHelper {
    
    static func populateFakeData() {
        // populate 2 years worth of fake data
        //
        var twoYearsAgo = Calendar.current.date(byAdding: .year, value: -2, to: Date())!

        let healthKitTypesToWrite: Set<HKSampleType> = [HKObjectType.workoutType()]
        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite, read: nil) { (success, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let healthStore = HKHealthStore()
            let workoutConfiguration = HKWorkoutConfiguration()
            workoutConfiguration.activityType = .other
            
            while twoYearsAgo < Date() {
                let workout = HKWorkout(activityType: .highIntensityIntervalTraining, start: twoYearsAgo, end: twoYearsAgo.advanced(by: Double.random(in: 3600...6000)))
                twoYearsAgo = twoYearsAgo.advanced(by: 24 * 3600)
                healthStore.save(workout) { result, error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                }
            }
        }
    }
}
