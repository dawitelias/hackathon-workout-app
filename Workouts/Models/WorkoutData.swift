//
//  WorkoutData.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/18/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import Foundation
import HealthKit
import SwiftUI

class WorkoutData: ObservableObject {
    // If the user has completed an activity in the past week,
    // we show the most recent activity that they finished on a map on the hompage
    //
    @Published var featuredWorkout: HKWorkout?
    
    // We want to show the user all of the workouts that they've done today, if they've done multiple,
    // otherwise, we will just fall back to displaying the 'featured' workout - which queries for the whole week
    //
    @Published var workoutsForToday: [HKWorkout]?

    // These are all of the workouts calculated with the current predicates applied in flat array and grouped by date
    //
    @Published var workouts: [HKWorkout] = [HKWorkout]()

    // Add in whatever activity types you want to see here, I just added default, if we can select multiple from the picker we can update this to hold array
    //
    @Published var activityTypeFilters: [ActivityTypeFilter] = [ActivityTypeFilter]()
    var activeActivityTypeFilters: [ActivityTypeFilter] {
        get {
            return activityTypeFilters.filter { return $0.isApplied }
        }
    }

    @Published var appliedFilters: [WorkoutFilter] = [WorkoutFilter]()
    
    var dateRangeFilter = DateRangeWorkoutFilter(startDate: Date(), endDate: Date(), isApplied: false, color: Color.getFlatUIColor())
    var calorieFilter = CaloriesWorkoutFilter(value: 500, isApplied: false, color: Color.getFlatUIColor())
    var distanceFilter = DistanceWorkoutFilter(value: 10, isApplied: false, color: Color.getFlatUIColor())
    var durationFilter = DurationWorkoutFilter(value: 9000, isApplied: false, color: Color.getFlatUIColor())
    
    private var healthKitAssistant = HealthKitAssistant()

    init() {
        setDefaultActivityTypeFilters()
        queryWorkouts()
    }
    
    private func setDefaultActivityTypeFilters() {
        let defaultActivityTypeFilters: [HKWorkoutActivityType] = [.walking, .running, .cycling, .yoga]

        // instantiate all of our activity type filters now
        //
        var allActivityFilters = HKWorkoutActivityType.allCases.map {
            return ActivityTypeFilter(value: $0, isApplied: defaultActivityTypeFilters.contains($0) ? true : false, color: Color.getFlatUIColor())
        }
        
        // Sort them alphabetically
        //
        allActivityFilters.sort(by: { return $0.value.workoutTypeMetadata.activityTypeDescription < $1.value.workoutTypeMetadata.activityTypeDescription })

        self.activityTypeFilters = allActivityFilters
    }
    
    func toggleActivityFilterApplied(filter: ActivityTypeFilter) {
        if let indexOfFilter = self.activityTypeFilters.lastIndex(of: filter) {
            self.activityTypeFilters[indexOfFilter].isApplied.toggle()
        }
        queryWorkouts()
    }
    
    func resetAllFilters() {
        setDefaultActivityTypeFilters()
        self.appliedFilters = [WorkoutFilter]()
    }
    
    private func getAppliedFilters() {
        var filters = [WorkoutFilter]()
        if dateRangeFilter.isApplied {
            filters.append(dateRangeFilter)
        }
        if durationFilter.isApplied {
            filters.append(durationFilter)
        }
        if distanceFilter.isApplied {
            filters.append(distanceFilter)
        }
        if calorieFilter.isApplied {
            filters.append(calorieFilter)
        }
        self.appliedFilters = filters
    }

    func queryWorkouts() {
        getAppliedFilters()
        healthKitAssistant.getWorkouts(types: activeActivityTypeFilters, predicates: appliedFilters.map { $0.predicate }) { [weak self] results, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard var workouts = results else {
                return
            }
            workouts.sort(by: { $0.startDate > $1.startDate })
            self?.workouts = workouts
            self?.getFeaturedWorkout()
            self?.getWorkoutsForToday()
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
    
    private func getWorkoutsForToday() {
        healthKitAssistant.getWorkoutsDoneToday { workouts, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self.workoutsForToday = workouts
            }
        }
    }
}
