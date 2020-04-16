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

    // MARK: Get Workouts by Activity Type
    //
    func getWorkoutsByType(type: HKWorkoutActivityType, completion: @escaping ([HKWorkout]?, Error?) -> Void) {

        checkAccess() { success, error in

            if !success || error != nil {
                completion(nil, error)
                return
            }
            
            let predicate = HKQuery.predicateForWorkouts(with: type)
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

            let query = HKSampleQuery(
                sampleType: .workoutType(),
                predicate: predicate,
                limit: 30, // MARK: <- Come back to this... ???
                sortDescriptors: [sortDescriptor]) { (query, samples, error) in
                    if error != nil {
                        completion(nil, error)
                        return
                    }

                    DispatchQueue.main.async {
                        if let workoutData = samples as? [HKWorkout] {
                            completion(workoutData, nil)
                        }
                    }
                }
            HKHealthStore().execute(query)
        }
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
                let walkingAndRunningDistance = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            
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
