//
//  HKWorkout+Extensions.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/15/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//
import HealthKit
import CoreLocation

struct WorkoutTypeMetadata {
    var systemIconName: String
    var activityDescription: String

    init(type: HKWorkoutActivityType) {
        switch type {
            case .running:
                self.systemIconName = "person.fill"
                self.activityDescription = "Running"
            case .swimming:
               self.systemIconName = "person.fill"
               self.activityDescription = "Swimming"
            case .cycling:
               self.systemIconName = "person.fill"
               self.activityDescription = "Cycling"
            case .walking:
                self.systemIconName = "person.fill"
                self.activityDescription = "Walking"
            default:
               self.systemIconName = "person.fill"
               self.activityDescription = "Some Other Activity Type"
        }
    }
}

extension HKWorkout {

    // Couple'a extra *bits* in the HKWorkout that will make it easy for us to get icons and activity types
    //
    var workoutTypeMetadata: WorkoutTypeMetadata {
        get {
            return WorkoutTypeMetadata(type: self.workoutActivityType)
        }
    }

    private func getWorkoutRouteSamples(completion: @escaping ([HKSample]?, Error?) -> Void) {
        let runningObjectQuery = HKQuery.predicateForObjects(from: self)

        let routeQuery = HKAnchoredObjectQuery(type: HKSeriesType.workoutRoute(), predicate: runningObjectQuery, anchor: nil, limit: HKObjectQueryNoLimit) { (query, samples, deletedObjects, anchor, error) in
            completion(samples, error)
        }
        HKHealthStore().execute(routeQuery)
    }

    func getWorkoutLocationData(completion: @escaping ([CLLocationCoordinate2D]?, Error?) -> Void) {
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
            var locationData = [CLLocationCoordinate2D]()

            locationSamples.forEach { sample in
                guard let routeSample = sample as? HKWorkoutRoute else {
                    return
                }

                dispatchGroup.enter()
                let routeQuery = HKWorkoutRouteQuery(route: routeSample) { (query, locations, done, error) in

                    if let locationResults = locations {
                        locationData += locationResults.map {
                            return CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
                        }
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
}
