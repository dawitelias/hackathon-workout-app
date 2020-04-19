//
//  WorkoutData.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/18/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import Foundation
import HealthKit

class WorkoutData: ObservableObject {
    // If the user has completed an activity in the past week,
    // we show the most recent activity that they finished on a map on the hompage
    //
    @Published var featuredWorkout: HKWorkout?

    // These are all of the workouts calculated with the current predicates applied in flat array and grouped by date
    //
    @Published var workouts: [HKWorkout] = [HKWorkout]()

    // Add in whatever activity types you want to see here, I just added default, if we can select multiple from the picker we can update this to hold array
    //
    @Published var activityTypeFilters: [HKWorkoutActivityType] = [.walking, .running, .cycling, .kickboxing]

    @Published var appliedFilters: [NSPredicate] = [NSPredicate]()
    
    var dateRangeFilter = DateRangeWorkoutFilter(startDate: Date(), endDate: Date(), isApplied: false)
    var calorieFilter = CaloriesWorkoutFilter(value: 500, isApplied: false)
    var distanceFilter = DistanceWorkoutFilter(value: 10, isApplied: false)
    var durationFilter = DurationWorkoutFilter(value: 2, isApplied: false)
    
    private var healthKitAssistant = HealthKitAssistant()

    init() {
        queryWorkouts()
    }
    
    func resetAllFilters() {
        self.activityTypeFilters = [.walking]
        self.appliedFilters = [NSPredicate]() // set this to an empty array
    }
    
    private func getAppliedFilters() {
        var filters = [NSPredicate]()
        if dateRangeFilter.isApplied {
            filters.append(dateRangeFilter.predicate)
        }
        if durationFilter.isApplied {
            filters.append(durationFilter.predicate)
        }
        if distanceFilter.isApplied {
            filters.append(distanceFilter.predicate)
        }
        if calorieFilter.isApplied {
            filters.append(calorieFilter.predicate)
        }
        self.appliedFilters = filters
    }

    func queryWorkouts() {
        getAppliedFilters()
        healthKitAssistant.getWorkouts(types: activityTypeFilters, predicates: appliedFilters) { [weak self] results, error in
            guard var workouts = results else {
                return
            }
            workouts.sort(by: { $1.startDate > $0.startDate })
            self?.workouts = workouts
            self?.getFeaturedWorkout()
        }
    }

    private func getFeaturedWorkout() {
        // Query for workouts done in last week, take the first one
        //
        healthKitAssistant.getFeaturedWorkout { featuredWorkout, error in
            if let error = error {
                // Alert user there was an issue getting the featured workout
                print(error.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self.featuredWorkout = featuredWorkout
            }
        }
    }
}
