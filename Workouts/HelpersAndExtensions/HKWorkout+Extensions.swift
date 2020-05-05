//
//  HKWorkout+Extensions.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/15/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//
import HealthKit
import CoreLocation

extension HKWorkout {
    private func getWorkoutRouteSamples(completion: @escaping ([HKSample]?, Error?) -> Void) {
        let runningObjectQuery = HKQuery.predicateForObjects(from: self)

        let routeQuery = HKAnchoredObjectQuery(type: HKSeriesType.workoutRoute(), predicate: runningObjectQuery, anchor: nil, limit: HKObjectQueryNoLimit) { (query, samples, deletedObjects, anchor, error) in
            completion(samples, error)
        }
        HKHealthStore().execute(routeQuery)
    }

    func getWorkoutLocationData(completion: @escaping ([CLLocation]?, Error?) -> Void) {
        self.getWorkoutRouteSamples() { (samples, error) in
            if let error = error {
                completion(nil, error)
                return
            }
    
            guard let locationSamples = samples else {
                return
            }

            // For each sample, we want to extract the location datazzz...
            //
            let dispatchGroup = DispatchGroup()
            var locationData = [CLLocation]()

            locationSamples.forEach { sample in
                guard let routeSample = sample as? HKWorkoutRoute else {
                    return
                }

                dispatchGroup.enter()
                let routeQuery = HKWorkoutRouteQuery(route: routeSample) { (query, locations, done, error) in

                    if let locationResults = locations {
                        locationData += locationResults
                    }
                    
                    if done {
                        dispatchGroup.leave()
                    }
                }
                HKHealthStore().execute(routeQuery)
            }
            // Call completion handler when we have finished perfoming all of the route queries
            //
            dispatchGroup.notify(queue: DispatchQueue.main) {
                completion(locationData, nil)
            }
        }
    }
    
    // Coming soon... to be displayed in a nice visualization
    //
    func getWorkoutHeartRateData() {
        
    }
}
