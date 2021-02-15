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
        HKQuery.predicateForWorkouts(with: value)
    }
}

struct DistanceWorkoutFilter: WorkoutFilter {

    var filterID = "distance"

    var value: Double

    var isApplied: Bool

    var color: Color {
        Color("AL_1")
    }

    var filterDescription: String {
        "\(value) mi +"
    }

    var predicate: NSPredicate {
        HKQuery.predicateForWorkouts(with: .greaterThanOrEqualTo, totalDistance: HKQuantity(unit: .mile(), doubleValue: value))
    }
}

struct CaloriesWorkoutFilter: WorkoutFilter {

    var filterID = "calories"

    var value: Double

    var isApplied: Bool

    var color: Color {
        Color("AB_1")
    }

    var filterDescription: String {
        "\(Int(value)) cal +"
    }

    var predicate: NSPredicate {
        HKQuery.predicateForWorkouts(with: .greaterThanOrEqualTo, totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: value))
    }
}

struct DurationWorkoutFilter: WorkoutFilter {

    var filterID = "duration"

    var value: Double

    var isApplied: Bool

    var color: Color {
        Color("AV_1")
    }

    var filterDescription: String {
        "\(TimeInterval(value).getHoursAndMinutesString()) +"
    }

    var predicate: NSPredicate {
        HKQuery.predicateForWorkouts(with: .greaterThanOrEqualTo, duration: value)
    }
}

struct DateRangeWorkoutFilter: WorkoutFilter {

    var filterID = "dateRange"

    var startDate: Date

    var endDate: Date

    var isApplied: Bool

    var color: Color {
        Color("Y_1")
    }

    var filterDescription: String {
        "\(startDate.month)/\(startDate.day) - \(endDate.month)/\(endDate.day)"
    }

    var predicate: NSPredicate {
        HKQuery.predicateForSamples(withStart: startDate, end: endDate)
    }
}
