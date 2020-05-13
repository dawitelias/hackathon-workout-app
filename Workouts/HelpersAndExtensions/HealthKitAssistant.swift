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
    func getWorkouts(types: [ActivityTypeFilter], predicates: [NSPredicate], completion: @escaping ([HKWorkout]?, Error?) -> Void) {
        checkAccess() { success, error in

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
                    limit: 100,
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
    
    // MARK: Get Featured Workout
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

    // MARK: Check Privacy and Device HealthKit Capabilities
    //
    private func checkAccess(completion: @escaping (Bool, Error?) -> Void) {
        
        guard let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
                let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType),
                let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
                let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
                let height = HKObjectType.quantityType(forIdentifier: .height),
                let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
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
            dateOfBirth,
            bloodType,
            biologicalSex,
            bodyMassIndex,
            height,
            bodyMass,
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
