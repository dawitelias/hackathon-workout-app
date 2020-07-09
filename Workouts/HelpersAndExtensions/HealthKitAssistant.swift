//
//  HealthKitHelper.swift
//  HealthKitSwiftUI
//
//  Created by Emily Cheroske on 4/15/20.
//  Copyright © 2020 Emily Cheroske. All rights reserved.
//

import Foundation
import HealthKit
import CoreLocation

class HealthKitAssistant {

    private enum HealthkitSetupError: Error {
      case notAvailableOnDevice
      case dataTypeNotAvailable
    }

    // MARK: Get workouts with predicates for each activity type
    //
    func getWorkoutsByType(types: [ActivityTypeFilter], predicates: [NSPredicate], completion: @escaping ([HKWorkout]?, Error?) -> Void) {
        HealthKitAssistant.checkAccess() { success, error in

            if !success || error != nil {
                completion(nil, error)
                return
            }

            let dispatchGroup = DispatchGroup()
            var workoutData = [HKWorkout]()

            types.forEach { activityType in
                var summedPredicates = predicates
                summedPredicates.append(HKQuery.predicateForWorkouts(with: activityType.value))
                let compound = NSCompoundPredicate(andPredicateWithSubpredicates: summedPredicates)
                let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
                
                dispatchGroup.enter()
                let query = HKSampleQuery(
                    sampleType: .workoutType(),
                    predicate: compound,
                    limit: HKObjectQueryNoLimit,
                    sortDescriptors: [sortDescriptor]) { (query, samples, error) in
                        
                        if error != nil {
                            dispatchGroup.leave()
                            completion(nil, error)
                            return
                        }

                        if let data = samples as? [HKWorkout] {
                            // workoutData += data Note* I ocassionaly get badAccess error thrown here crashing the app (only on app startup), very hard to repro going to try another way of copying over these array contents and see if I see the same error popup again.
                            workoutData.append(contentsOf: data)
                        }
                        dispatchGroup.leave()
                    }
                HKHealthStore().execute(query)
            }
            
            dispatchGroup.notify(queue: .main) {
                completion(workoutData, nil)
            }
            
        }
    }
    
    func getAllWorkouts(predicates: [NSPredicate], completion: @escaping ([HKWorkout]?, Error?) -> Void) {
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

        let query = HKSampleQuery(
            sampleType: .workoutType(),
            predicate: NSCompoundPredicate(andPredicateWithSubpredicates: predicates),
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sortDescriptor]) { (query, samples, error) in
                
                if error != nil {
                    completion(nil, error)
                    return
                }

                if let data = samples as? [HKWorkout] {
                    completion(data, nil)
                }
            }
        HKHealthStore().execute(query)
    }
    
    // MARK: Get Workouts Done Today
    func getWorkoutsDoneToday(completion: @escaping ([HKWorkout]?, Error?) -> Void) {
        // Query for workouts done in since midnight, return all of them
        //
        let cal = Calendar(identifier: .gregorian)
        let midnight = cal.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: midnight, end: Date(), options: [])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

        let query = HKSampleQuery(
            sampleType: .workoutType(),
            predicate: predicate,
            limit: 10,
            sortDescriptors: [sortDescriptor]) { (query, samples, error) in
                
                if error != nil {
                    completion(nil, error)
                    return
                }

                if let data = samples as? [HKWorkout] {
                    completion(data, error)
                }
            }
        HKHealthStore().execute(query)
    }
    
    // Get workouts over time interval in neat buckets
    //
    func getWorkoutsDonePastWeek(completion: @escaping ([[HKWorkout]?]?, Error?) -> Void) {

        // Get the date 7 days back
        //
        let numberOfDaysBack = 7
        let startDate = Calendar.current.date(byAdding: .day, value: -numberOfDaysBack, to: Date())
        
        // For each day we want to get all of the workouts for each day
        // Shove all of these async calls into a dispatch group, call completion when they've all finished
        //
        let dispatchGroup = DispatchGroup()
        var workoutResults = [[HKWorkout]]()

        for i in 0...(numberOfDaysBack + 1) {
            dispatchGroup.enter()
            let start = startDate?.advanced(by: 60 * 60 * 24 * Double(i)) ?? Date()
            let end = startDate?.advanced(by: 60 * 60 * 24 * Double(i + 1)) ?? Date()
            let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: [])
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            let query = HKSampleQuery(
                sampleType: .workoutType(),
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sortDescriptor]) { (query, samples, error) in
                    
                    if error != nil {
                        dispatchGroup.leave()
                        return
                    }

                    if let data = samples as? [HKWorkout] {
                        workoutResults.append(data)
                        dispatchGroup.leave()
                    }
                }
            HKHealthStore().execute(query)
        }
        
        dispatchGroup.notify(queue: .main) {
            // TODO: need to sory these workouts by date since async calls doesn't guarantee we will
            // get them back in the right order.
            //
            completion(workoutResults, nil)
        }
    }
    
    // MARK: Get Featured Workout
    //
    func getFeaturedWorkout(completion: @escaping (HKWorkout?, Error?) -> Void) {
        // Query for workouts done in last week, take the first one
        //
        let predicate = HKQuery.predicateForSamples(withStart: Date().hoursBeforeNow(hr: 24*7), end: Date(), options: [])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

        let query = HKSampleQuery(
            sampleType: .workoutType(),
            predicate: predicate,
            limit: 1,
            sortDescriptors: [sortDescriptor]) { (query, samples, error) in
                
                if error != nil {
                    completion(nil, error)
                    return
                }

                if let data = samples as? [HKWorkout] {
                    completion(data.first, error)
                }
            }
        HKHealthStore().execute(query)
    }
    
    // MARK: Get Number of Workouts per day in a grouped format
    //
    static func getNumWorkoutsPerDay(numMonthsBack: Int, plusDays: Int, completion: @escaping ([Date: [HKWorkout]]?, Error?) -> Void) {
        // Get the date 3 months back
        //
        var date = Calendar.current.date(byAdding: .month, value: -numMonthsBack, to: Date())
        date = date?.advanced(by: -Double(plusDays * 24 * 60 * 60))
        
        // Query the workouts for this timeframe
        //
        let predicate = HKQuery.predicateForSamples(withStart: date, end: Date(), options: [])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(
            sampleType: .workoutType(),
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sortDescriptor]) { (query, samples, error) in
                
                if error != nil {
                    completion(nil, error)
                    return
                }

                if let data = samples as? [HKWorkout] {
                    let empty: [Date: [HKWorkout]] = [:]
                    let grouped = data.reduce(into: empty) { acc, cur in
                        let components = Calendar.current.dateComponents([.year, .month, .day], from: cur.startDate)
                        let d = Calendar.current.date(from: components)!
                        let existing = acc[d] ?? []
                        acc[d] = existing + [cur]
                    }
                    completion(grouped, nil)
                }
            }
        HKHealthStore().execute(query)
    }

    // MARK: Get Number of Workouts per week in a grouped format
    //
    static func getNumWorkoutsPerWeek(numMonthsBack: Int, completion: @escaping ([Date: [HKWorkout]]?, Error?) -> Void) {
        // Get the date 3 months back
        //
        var date = Calendar.current.date(byAdding: .month, value: -numMonthsBack, to: Date())
        
        // Query the workouts for this timeframe
        //
        let predicate = HKQuery.predicateForSamples(withStart: date, end: Date(), options: [])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(
            sampleType: .workoutType(),
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sortDescriptor]) { (query, samples, error) in
                
                if error != nil {
                    completion(nil, error)
                    return
                }

                if let data = samples as? [HKWorkout] {
                    let empty: [Date: [HKWorkout]] = [:]
                    let grouped = data.reduce(into: empty) { acc, cur in
                        let components = Calendar.current.dateComponents([.weekOfYear, .yearForWeekOfYear], from: cur.startDate)
                        let d = Calendar.current.date(from: components)!
                        let existing = acc[d] ?? []
                        acc[d] = existing + [cur]
                    }
                    completion(grouped, nil)
                }
            }
        HKHealthStore().execute(query)
    }

    // MARK: Check Privacy and Device HealthKit Capabilities
    //
    static public func checkAccess(completion: @escaping (Bool, Error?) -> Void) {
        
        guard
                let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
                let cyclingDistance = HKObjectType.quantityType(forIdentifier: .distanceCycling),
                let walkingAndRunningDistance = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
                let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            
                completion(false, HealthkitSetupError.dataTypeNotAvailable)
                return
        }

        // Health Kit Data Types we request permission to read
        //
        let healthKitTypesToRead: Set<HKObjectType> = [
            activeEnergy,
            cyclingDistance,
            walkingAndRunningDistance,
            heartRate,
            HKObjectType.workoutType(),
            HKSeriesType.workoutRoute()]
        
        // Check if the device has HealthKit capabilities
        //
        if HKHealthStore.isHealthDataAvailable() {
            
            // Request authorization
            //
            HKHealthStore().requestAuthorization(toShare: nil, read: healthKitTypesToRead) { (success, error) in
                completion(success, error)
            }
        } else {
            completion(false, HealthkitSetupError.notAvailableOnDevice)
        }
    }
}
