//
//  HKWorkout+Extensions.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/15/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//
import Foundation
import UIKit
import SwiftUI
import HealthKit
import CoreLocation

extension HKWorkout {

    private func getWorkoutRouteSamples(completion: @escaping ([HKSample]?, Error?) -> Void) {

        let routeQuery = HKAnchoredObjectQuery(
            type: HKSeriesType.workoutRoute(),
            predicate: HKQuery.predicateForObjects(from: self),
            anchor: nil,
            limit: HKObjectQueryNoLimit) { (query, samples, deletedObjects, anchor, error) in
            completion(samples, error)
        }

        HKHealthStore().execute(routeQuery)
    }

    func getWorkoutLocationData(completion: @escaping ([CLLocation]?, Error?) -> Void) {

        getWorkoutRouteSamples() { (samples, error) in

            guard error == nil, let locationSamples = samples else {
                completion(nil, error)
                return
            }

            // For each sample, we want to extract the location datazzz...
            //
            let dispatchGroup = DispatchGroup()
            var locationData = [CLLocation]()

            locationSamples.forEach { sample in

                if let routeSample = sample as? HKWorkoutRoute {

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

            }

            // Call completion handler when we have finished perfoming all of the route queries
            //
            dispatchGroup.notify(queue: DispatchQueue.main) {
                completion(locationData, nil)
            }
        }
    }
    
    var weatherHumidity: Double {
        (metadata?["HKWeatherHumidity"] as? HKQuantity)?.doubleValue(for: .percent()) ?? 0
    }
    
    var weatherTemperature: Double {
        (metadata?["HKWeatherTemperature"] as? HKQuantity)?.doubleValue(for: .degreeFahrenheit()) ?? 0
    }
    
    func getWorkoutHeartRateData(completion: @escaping ([HeartRateReading]?, Error?) -> Void) {

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
        let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
        
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            completion(nil, nil)
            return
        }
        
        let heartRateQuery = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: sortDescriptors) { query, results, error  in
            
            guard error == nil else {
                completion(nil, error)
                return
            }

            let heartRateUnit: HKUnit = HKUnit.count().unitDivided(by: HKUnit.minute())

            let results: [HeartRateReading]? = results?.reversed().map {

                guard let data = $0 as? HKQuantitySample else {
                    return HeartRateReading(reading: 0, date: $0.startDate)
                }

                return HeartRateReading(reading: data.quantity.doubleValue(for: heartRateUnit), date: $0.startDate)
            }

            completion(results, nil)
        }

        HKHealthStore().execute(heartRateQuery)
    }

    private func imageName(for colorScheme: ColorScheme) -> String {
        "\(uuid)_\(colorScheme == .dark ? "dark" : "light").png"
    }

    func writeImageToDocumentsDirectory(image: UIImage, colorScheme: ColorScheme) {

        let imageURL = documentsDirectoryURL.appendingPathComponent(imageName(for: colorScheme))

        if let data = image.pngData() {
            do {
                try data.write(to: imageURL, options: .atomic)
            } catch {
                print("error writing image: \(error.localizedDescription)")
            }
        }
    }

    func getImageFromDocumentsDirectory(colorScheme: ColorScheme) -> UIImage? {

        let mapCardPhotosPath = documentsDirectoryURL.appendingPathComponent(imageName(for: colorScheme))

        return FileManager.default.fileExists(atPath: mapCardPhotosPath.path) ? UIImage(contentsOfFile: mapCardPhotosPath.path) : nil
    }
}
