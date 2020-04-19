//
//  FilterTypes.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/18/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import Foundation
import HealthKit

struct DistanceWorkoutFilter {
    var value: Double
    var isApplied: Bool
    var predicate: NSPredicate {
        return HKQuery.predicateForWorkouts(with: .lessThanOrEqualTo, totalDistance: HKQuantity(unit: .mile(), doubleValue: value))
    }

    init(defaultValue: Double, isApplied: Bool) {
        self.value = defaultValue
        self.isApplied = isApplied
    }
}
struct CaloriesWorkoutFilter {
    var value: Double
    var isApplied: Bool
    var predicate: NSPredicate {
        return HKQuery.predicateForWorkouts(with: .lessThanOrEqualTo, totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: value))
    }

    init(defaultValue: Double, isApplied: Bool) {
        self.value = defaultValue
        self.isApplied = isApplied
    }
}
struct DurationWorkoutFilter {
    var value: Double
    var isApplied: Bool
    var predicate: NSPredicate {
        return HKQuery.predicateForWorkouts(with: .lessThanOrEqualTo, duration: value)
    }
    init(defaultValue: Double, isApplied: Bool) {
        self.value = defaultValue
        self.isApplied = isApplied
    }
}
struct DateRangeWorkoutFilter {
    var startDate: Date
    var endDate: Date
    var isApplied: Bool
    var predicate: NSPredicate {
        return HKQuery.predicateForSamples(withStart: startDate, end: endDate)
    }
    
    init(startDate: Date, endDate: Date, isApplied: Bool) {
        self.startDate = startDate
        self.endDate = endDate
        self.isApplied = isApplied
    }
}
