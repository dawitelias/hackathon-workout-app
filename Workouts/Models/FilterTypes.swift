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
    var filterID: String { get }
    var isApplied: Bool { get set }
    var predicate: NSPredicate { get }
    var color: Color { get }
    var filterDescription: String { get }
}

struct ActivityTypeFilter: Hashable {
    var value: HKWorkoutActivityType
    var isApplied: Bool
    var color: Color
    var predicate: NSPredicate {
        return HKQuery.predicateForWorkouts(with: value)
    }
}
struct DistanceWorkoutFilter: WorkoutFilter {
    var filterID = "distance"
    var value: Double
    var isApplied: Bool
    var color: Color {
        get {
            return Color("AL_1")
        }
    }
    var filterDescription: String {
        get {
            return "\(value) mi +"
        }
    }
    var predicate: NSPredicate {
        return HKQuery.predicateForWorkouts(with: .greaterThanOrEqualTo, totalDistance: HKQuantity(unit: .mile(), doubleValue: value))
    }
}
struct CaloriesWorkoutFilter: WorkoutFilter {
    var filterID = "calories"
    var value: Double
    var isApplied: Bool
    var color: Color {
        get {
            return Color("AB_1")
        }
    }
    var filterDescription: String {
        get {
            return "\(Int(value)) cal +"
        }
    }
    var predicate: NSPredicate {
        return HKQuery.predicateForWorkouts(with: .greaterThanOrEqualTo, totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: value))
    }
}
struct DurationWorkoutFilter: WorkoutFilter {
    var filterID = "duration"
    var value: Double
    var isApplied: Bool
    var color: Color {
        get {
            return Color("AV_1")
        }
    }
    var filterDescription: String {
        get {
            return "\(TimeInterval(value).getHoursAndMinutesString()) +"
        }
    }
    var predicate: NSPredicate {
        return HKQuery.predicateForWorkouts(with: .greaterThanOrEqualTo, duration: value)
    }
}
struct DateRangeWorkoutFilter: WorkoutFilter {
    var filterID = "dateRange"
    var startDate: Date
    var endDate: Date
    var isApplied: Bool
    var color: Color {
        get {
            return Color("Y_1")
        }
    }
    var filterDescription: String {
        get {
            return "\(startDate.month)/\(startDate.day) - \(endDate.month)/\(endDate.day)"
        }
    }
    var predicate: NSPredicate {
        return HKQuery.predicateForSamples(withStart: startDate, end: endDate)
    }
}
