//
//  WorkoutDataHelper.swift
//  Okapi
//
//  Created by Emily Cheroske on 2/10/21.
//  Copyright © 2021 Dawit Elias. All rights reserved.
//

//import Foundation
//import HealthKit
//import CoreLocation
//
//class WorkoutDataHelper {
//    
//    public static func populateEachActivityType() {
//        
//        let healthStore = HKHealthStore()
//        
//        HKWorkoutActivityType.allCases.forEach { activityType in
//            
//            let routeBuilder = HKWorkoutRouteBuilder(healthStore: healthStore, device: nil)
//            
//            var route: [CLLocation] = []
//            route.append(CLLocation(latitude: CLLocationDegrees(70.2), longitude: CLLocationDegrees(47.9)))
//            route.append(CLLocation(latitude: CLLocationDegrees(71.2), longitude: CLLocationDegrees(47.9)))
//            route.append(CLLocation(latitude: CLLocationDegrees(72.2), longitude: CLLocationDegrees(47.9)))
//            route.append(CLLocation(latitude: CLLocationDegrees(70.2), longitude: CLLocationDegrees(47.9)))
//            
//            let startDate = DateComponents(calendar: .current, year: 2021, month: 1, day: 7, hour: 10, minute: 1, second: 40).date!
//            let endDate = startDate.advanced(by: 3600) // one hour from now
//
//            let workoutEvents: [HKWorkoutEvent] = [
//                HKWorkoutEvent(type: .pause, date: startDate.advanced(by: 300)),
//                HKWorkoutEvent(type: .resume, date: startDate.advanced(by: 600))
//            ]
//
//            // 1,000 kilojoules
//            let totalEnergyBurned = HKQuantity(unit: HKUnit.jouleUnit(with: .kilo), doubleValue: 1000)
//
//            // 3 KM distance
//            let totalDistance = HKQuantity(unit: HKUnit.meter(), doubleValue: 3000)
//
//            let metadata: [String: Bool] = [
//                HKMetadataKeyGroupFitness: true,
//                HKMetadataKeyIndoorWorkout: false,
//                HKMetadataKeyCoachedWorkout: true
//            ]
//
//            let workout = HKWorkout(
//                activityType: activityType,
//                start: startDate,
//                end: endDate,
//                workoutEvents: workoutEvents,
//                totalEnergyBurned: totalEnergyBurned,
//                totalDistance: totalDistance,
//                device: nil,
//                metadata: metadata
//            )
//            
//            healthStore.save(workout) { _, error in
//                if let error = error {
//                    print("Error saving workout: \(error.localizedDescription)")
//                }
//                
//                routeBuilder.insertRouteData(route) { success, error in
//                    if let error = error {
//                        print("Error associating route in routeBuilder: \(error.localizedDescription)")
//                    }
//
//                    routeBuilder.finishRoute(with: workout, metadata: metadata) { _, error in
//                        if let error = error {
//                            print("Error savign workout with route data: \(error.localizedDescription)")
//                        }
//
//                    }
//
//                }
//
//            }
//
//        }
//
//    }
//
//}
