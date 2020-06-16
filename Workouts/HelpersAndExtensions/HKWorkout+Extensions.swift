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
    
    func getWeatherHumidity() -> Double? {
        let humidityKey = "HKWeatherHumidity"
        return (self.metadata?[humidityKey] as? HKQuantity)?.doubleValue(for: .percent()) ?? 0
    }
    
    func getWeatherTemperature() -> Double? {
        let temperatureKey = "HKWeatherTemperature"
        return (self.metadata?[temperatureKey] as? HKQuantity)?.doubleValue(for: .degreeFahrenheit()) ?? 0
    }
    
    func getWorkoutHeartRateData(completion: @escaping ([Double]?, Error?) -> Void) {
        let startDate = self.startDate
        let endDate = self.endDate

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
        let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
        
        guard let sampleType = HKObjectType
          .quantityType(forIdentifier: .heartRate) else {
            
          return
        }
        
        let heartRateQuery = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: sortDescriptors) { query, results, error  in
            if let error = error {
                completion(nil, error)
                return
            }
            let heartRateUnit: HKUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
            let results: [Double]? = results?.map { item in
                guard let currData:HKQuantitySample = item as? HKQuantitySample else { return 0 }
                return currData.quantity.doubleValue(for: heartRateUnit)
            }
            
            completion(results, nil)
        }
        HKHealthStore().execute(heartRateQuery)
    }
}
