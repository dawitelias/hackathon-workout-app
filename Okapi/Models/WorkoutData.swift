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

    // Show the most recent workout on the homepage
    //
    @Published var mostRecentWorkout: HKWorkout?
    
    // If the user has done multiple workouts today, show aggregated stats across all workouts for the day
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
            activityTypeFilters.filter { $0.isApplied }
        }
    }

    @Published var appliedFilters: [WorkoutFilter] = [WorkoutFilter]()

    @Published var settings: UserSettings = UserSettings()

    var dateRangeFilter = DateRangeWorkoutFilter(startDate: Date(), endDate: Date(), isApplied: false)
    var calorieFilter = CaloriesWorkoutFilter(value: 500, isApplied: false)
    var distanceFilter = DistanceWorkoutFilter(value: 10, isApplied: false)
    var durationFilter = DurationWorkoutFilter(value: 9000, isApplied: false)

    var totalWorkoutsAllTime: Int?
    var totalWorkoutsThisMonth: Int?
    var totalWorkoutsThisWeek: Int?

    private var healthKitAssistant = HealthKitAssistant()

    init() {
        setDefaultActivityTypeFilters()
        queryWorkouts()
        queryWorkoutCounts()
    }

    private func setDefaultActivityTypeFilters() {

        let defaultActivityTypeFilters = [HKWorkoutActivityType]()

        // instantiate all of our activity type filters now
        //
        var allActivityFilters = HKWorkoutActivityType.allCases.map {
            ActivityTypeFilter(value: $0, isApplied: defaultActivityTypeFilters.contains($0) ? true : false, color: Color("D_2"))
        }
        
        // Sort them alphabetically
        //
        allActivityFilters.sort(by: { $0.value.workoutTypeMetadata.activityTypeDescription < $1.value.workoutTypeMetadata.activityTypeDescription })

        activityTypeFilters = allActivityFilters
    }
    
    func toggleActivityFilterApplied(filter: ActivityTypeFilter) {

        guard let indexOfFilter = activityTypeFilters.lastIndex(of: filter) else {
            return
        }

        activityTypeFilters[indexOfFilter].isApplied.toggle()

        queryWorkouts()
    }

    func toggleWorkoutFilterApplied(filter: WorkoutFilter) {
        switch filter.filterID {
        case "distance":
            distanceFilter.isApplied.toggle()
        case "calories":
            calorieFilter.isApplied.toggle()
        case "duration":
            durationFilter.isApplied.toggle()
        case "dateRange":
            dateRangeFilter.isApplied.toggle()
        default:
            print("unknown filter found.")
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

    public func queryWorkouts() {

        getAppliedFilters()

        if activeActivityTypeFilters.count == 0 {

            healthKitAssistant.getAllWorkouts(predicates: appliedFilters.map { $0.predicate }) { [weak self] results, error in
                
                guard error == nil, var workouts = results else {
                    return
                }

                workouts = workouts.filter { $0.startDate < Date() }
                workouts.sort(by: { $0.startDate > $1.startDate })

                DispatchQueue.main.async {
                    self?.workouts = workouts
                    self?.getFeaturedWorkout()
                    self?.getWorkoutsForToday()
                }

            }

        } else {

            healthKitAssistant.getWorkoutsByType(types: activeActivityTypeFilters, predicates: appliedFilters.map { $0.predicate }) { [weak self] results, error in

                guard error == nil,
                      let mySelf = self,
                      var workouts = results else {
                    return
                }

                workouts.sort(by: { $0.startDate > $1.startDate })

                DispatchQueue.main.async {
                    mySelf.workouts = workouts
                    mySelf.getFeaturedWorkout()
                    mySelf.getWorkoutsForToday()
                }
            }
        }
    }
    
    private func queryWorkoutCounts() {

        healthKitAssistant.getAllWorkouts(predicates: []) { [weak self] results, error in

            guard error == nil,
                  let mySelf = self,
                  let oneWeekAgo = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date()),
                  let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date()) else {
                return
            }

            mySelf.totalWorkoutsAllTime = results?.count ?? 0
            mySelf.totalWorkoutsThisMonth = results?.filter { $0.startDate > oneMonthAgo }.count
            mySelf.totalWorkoutsThisWeek = results?.filter { $0.startDate > oneWeekAgo }.count

        }

    }

    // TODO: Modify this logic so that it's just showing the most recent workout instead
    //
    private func getFeaturedWorkout() {

        // Query for workouts done in last week, take the first one
        //
        healthKitAssistant.getFeaturedWorkout { [weak self] featuredWorkout, error in

            guard error == nil, let mySelf = self else {
                return
            }

            DispatchQueue.main.async {
                mySelf.mostRecentWorkout = featuredWorkout
            }

        }

    }

    private func getWorkoutsForToday() {

        healthKitAssistant.getWorkoutsDoneToday { [weak self] workouts, error in
            guard error == nil, let mySelf = self else {
                return
            }

            DispatchQueue.main.async {
                mySelf.workoutsForToday = workouts
            }

        }

    }

}
