//
//  WorkoutHistoryViewModel.swift
//  Workouts
//
//  Created by Emily Cheroske on 11/14/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import Foundation
import HealthKit

class WorkoutHistoryViewModel: ObservableObject {

    // MARK: Published properties
    //
    @Published var dailyCaloriesData: [(String, Int)]? = nil

    @Published var dailyWorkoutDurationData: [(String, Int)]? = nil

    @Published var dailyWorkoutDistanceData: [(String, Int)]? = nil

    @Published var restingHeartRateData: [Double]? = nil

    @Published var allTimeCompletedWorkouts: Int? = nil

    @Published var workoutsCompletedThisMonth: Int = 10

    @Published var workoutsCompletedThisWeek: Int = 20

    init() {
        // Load workout simple data
        //
        loadNumberOfAllTimeWorkouts()
        loadWorkoutsCompletedThisWeek()
        loadNumberOfWorkoutsThisMonth()

        // Load chart data
        //
        loadCaloriesData()
        loadWorkoutDurationData()
        loadWorkoutDistanceData()
    }

    // MARK: Data loader helpers
    //
    private func loadNumberOfAllTimeWorkouts() {
        allTimeCompletedWorkouts = 10
    }
    
    private func loadNumberOfWorkoutsThisMonth() {
        workoutsCompletedThisMonth = 5
    }

    private func loadWorkoutsCompletedThisWeek() {
        workoutsCompletedThisWeek = 2
    }

    private func loadCaloriesData() {

        // Date formatter for daily calories data
        //
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"

        var interval = DateComponents()
        interval.day = 1

        // Set the anchor date to three days ago
        //
        var anchorComponents = NSCalendar.current.dateComponents([.day, .month, .year, .weekday], from: Date())
        anchorComponents.day = (anchorComponents.day ?? 0) - 3

        guard let anchorDate = NSCalendar.current.date(from: anchorComponents), let quanityType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            return
        }

        let caloriesQuery = HKStatisticsCollectionQuery(quantityType: quanityType, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: interval)

        caloriesQuery.initialResultsHandler = { query, results, error in
            guard error == nil, let statsCollection = results else {
                return
            }

            // We want to grab the samples in between today and seven days ago
            //
            let endDate = Date()
            guard let startDate = NSCalendar.current.date(byAdding: .day, value: -7, to: endDate) else {
                return
            }
            
            statsCollection.enumerateStatistics(from: startDate, to: endDate) { [weak self, weak dateFormatter] statistics, stop in
                if let quantity = statistics.sumQuantity() {

                    let date = dateFormatter?.string(from: statistics.startDate) ?? statistics.startDate.description
                    let value = Int(quantity.doubleValue(for: HKUnit.kilocalorie()))
                    
                    // TODO: remove these print statements
                    //
                    print("date: \(date)")
                    print("value: \(value)")

                    //self?.dailyCaloriesData?.append((date, value))
                } else {
                    print("no sumQuantity")
                }
            }
        }

        HKHealthStore().execute(caloriesQuery)
    }

    private func loadRestingHeartRateData() {

        // We want to look at your resting heart rate each day over the past three months
        //
        var interval = DateComponents()
        interval.day = 1

        // Offset the anchor date by 30 days even thought it doesn't really matter (according to Apple)
        //
        var anchorComponents = Calendar.current.dateComponents([.day, .month, .year, .weekday], from: Date())
        anchorComponents.day = (anchorComponents.day ?? 0) - 30

        guard let anchorDate = Calendar.current.date(from: anchorComponents), let quanityType = HKObjectType.quantityType(forIdentifier: .restingHeartRate) else {
            return
        }

        let restingHeartRateQuery = HKStatisticsCollectionQuery(quantityType: quanityType, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: interval)

        restingHeartRateQuery.initialResultsHandler = { query, results, error in
            guard error == nil, let statsCollection = results else {
                return
            }

            // We want to grab the samples in between today and seven days ago
            //
            let endDate = Date()
            guard let startDate = Calendar.current.date(byAdding: .month, value: -3, to: endDate) else {
                return
            }

            statsCollection.enumerateStatistics(from: startDate, to: endDate) { [weak self] statistics, stop in
                if let quantity = statistics.sumQuantity() {

                    let value = quantity.doubleValue(for: HKUnit.count())

                    // TODO: remove these print statements
                    //
                    print("restingHeartRateCalue: \(value)")

                    self?.restingHeartRateData?.append(value)
                }
            }
        }

        HKHealthStore().execute(restingHeartRateQuery)
    }

    private func loadWorkoutDurationData() {
        // TODO: populate with real duration data
        //
        dailyWorkoutDurationData = [
            ("11/8", 50),
            ("11/9", 10),
            ("11/10", 50),
            ("11/11", 45),
            ("11/12", 20),
            ("11/13", 30)
        ]
    }

    private func loadWorkoutDistanceData() {
        // TODO: populate with real data
        //
        dailyWorkoutDistanceData = [
            ("11/8", 8),
            ("11/9", 7),
            ("11/10", 6),
            ("11/11", 2),
            ("11/12", 10),
            ("11/13", 3)
        ]
    }
}
