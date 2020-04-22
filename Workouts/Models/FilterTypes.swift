//
//  FilterTypes.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/18/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import Foundation
import HealthKit
import SwiftUI

protocol WorkoutFilter {
    var isApplied: Bool { get set }
    var predicate: NSPredicate { get }
    var color: Color { get }
}

struct ActivityTypeFilter: WorkoutFilter, Hashable {
    var value: HKWorkoutActivityType
    var isApplied: Bool
    var color: Color
    var predicate: NSPredicate {
        return HKQuery.predicateForWorkouts(with: value)
    }
}
struct DistanceWorkoutFilter: WorkoutFilter {
    var value: Double
    var isApplied: Bool
    var color: Color
    var predicate: NSPredicate {
        return HKQuery.predicateForWorkouts(with: .lessThanOrEqualTo, totalDistance: HKQuantity(unit: .mile(), doubleValue: value))
    }
}
struct CaloriesWorkoutFilter: WorkoutFilter {
    var value: Double
    var isApplied: Bool
    var color: Color
    var predicate: NSPredicate {
        return HKQuery.predicateForWorkouts(with: .lessThanOrEqualTo, totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: value))
    }
}
struct DurationWorkoutFilter: WorkoutFilter {
    var value: Double
    var isApplied: Bool
    var color: Color
    var predicate: NSPredicate {
        return HKQuery.predicateForWorkouts(with: .lessThanOrEqualTo, duration: value)
    }
}
struct DateRangeWorkoutFilter: WorkoutFilter {
    var startDate: Date
    var endDate: Date
    var isApplied: Bool
    var color: Color
    var predicate: NSPredicate {
        return HKQuery.predicateForSamples(withStart: startDate, end: endDate)
    }
}
