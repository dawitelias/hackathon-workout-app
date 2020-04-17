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
    
    // If the user has completed an activity in the past week,
    // we show the most recent activity that they finished on a map on the hompage
    //
    @Published var featuredWorkout: HKWorkout?

    // These are all of the workouts calculated with the current predicates applied in flat array and grouped by date
    //
    @Published var workouts: [HKWorkout] = [HKWorkout]()
    @Published var workoutsGroupedByDate: [String: [HKWorkout]] = [String: [HKWorkout]]()

    // Add in whatever activity types you want to see here, I just added default, if we can select multiple from the picker we can update this to hold array
    //
    @Published var activityTypeFilters: [HKWorkoutActivityType] = [.walking, .running, .cycling, .kickboxing]
    
    // Date Filters
    //
    @Published var startDateFilter: Date?
    @Published var endDateFilter: Date?
    
    // Distance Filters
    //
    @Published var minDistanceFilter: Double?
    @Published var maxDistanceFilter: Double?
    
    // Calorie Filters
    //
    @Published var maxEnergyBurnedFilter: Double?
    @Published var minEnergyBurnedFilter: Double?
    
    private var healthKitAssistant = HealthKitAssistant()

    init() {
        queryWorkouts()
    }
    
    func resetAllFilters() {
        self.activityTypeFilters = [.walking]
        self.startDateFilter = nil
        self.endDateFilter = nil
        self.maxDistanceFilter = nil
        self.minDistanceFilter = nil
        self.minEnergyBurnedFilter = nil
        self.maxEnergyBurnedFilter = nil
    }
    
    func getAllPredicates() -> [NSPredicate] {
        var predicates = [NSPredicate]()
        
        // Add in our date predicate, if no end date filter applied then use the current date
        //
        if let startQueryDate = self.startDateFilter, let endQueryDate = self.endDateFilter {
            predicates.append(HKQuery.predicateForSamples(withStart: startQueryDate, end: endQueryDate))
        } else if let startQueryDate = self.startDateFilter {
            predicates.append(HKQuery.predicateForSamples(withStart: startQueryDate, end: Date()))
        }
        
        // Add in our distance predicate (miles)
        //
        if let maxDistance = self.maxDistanceFilter, let minDistance = self.minDistanceFilter {
            predicates.append(HKQuery.predicateForWorkouts(with: .greaterThanOrEqualTo, totalDistance: HKQuantity(unit: .mile(), doubleValue: minDistance)))
            predicates.append(HKQuery.predicateForWorkouts(with: .lessThanOrEqualTo, totalDistance: HKQuantity(unit: .mile(), doubleValue: maxDistance)))
        } else if let maxDistance = self.maxDistanceFilter {
            predicates.append(HKQuery.predicateForWorkouts(with: .lessThanOrEqualTo, totalDistance: HKQuantity(unit: .mile(), doubleValue: maxDistance)))
        }
        
        // Add in our energy predicates
        //
        if let maxEnergy = self.maxEnergyBurnedFilter, let minEnergy = self.minEnergyBurnedFilter {
            predicates.append(HKQuery.predicateForWorkouts(with: .greaterThanOrEqualTo, totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: minEnergy)))
            predicates.append(HKQuery.predicateForWorkouts(with: .lessThanOrEqualTo, totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: maxEnergy)))
        } else if let maxEnergy = self.maxEnergyBurnedFilter {
            predicates.append(HKQuery.predicateForWorkouts(with: .lessThanOrEqualTo, totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: maxEnergy)))
        }

        return predicates
    }
    
    func queryWorkouts() {
        let allPredicates = getAllPredicates()
        healthKitAssistant.getWorkoutsByTypes(types: activityTypeFilters, predicates: allPredicates) { [weak self] results, error in
            guard let workouts = results else {
                return
            }
            self?.workouts = workouts
            self?.workouts.sort(by: { $0.startDate > $1.startDate })
            if let sortedWorkouts = self?.workouts {
                self?.groupWorkouts(workouts: sortedWorkouts)
            }
            self?.getFeaturedWorkout()
        }
    }

    private func groupWorkouts(workouts: [HKWorkout]) {
        self.workoutsGroupedByDate = Dictionary(grouping: workouts, by: { ("\($0.startDate.month) \($0.startDate.year)") })
    }
    
    private func getFeaturedWorkout() {
        // Query for workouts done in last week, take the first one
        //
        let predicate = HKQuery.predicateForSamples(withStart: self.hoursBeforeNow(hr: 24*7), end: Date(), options: [])

        healthKitAssistant.getWorkouts(predicates: [predicate]) { [weak self] results, error in
            self?.featuredWorkout = results?.first
        }
    }
    private func hoursBeforeNow(hr:TimeInterval) -> Date {
        return Date().addingTimeInterval(-3600 * hr)
    }
}
