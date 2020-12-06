//
//  WorkoutDetailViewModel.swift
//  Workouts
//
//  Created by Emily Cheroske on 11/28/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import Foundation
import SwiftUI
import HealthKit
import CoreLocation

class WorkoutDetailViewModel: ObservableObject {

    let workout: HKWorkout

    @Published var route: [CLLocation]? = nil
    @Published var workoutHRData: [HeartRateReading]? = nil

    @Published var errorFetchingRouteData = false
    @Published var errorFetchingWorkoutHRData = false
    
    private var chartXAxisFormatter: DateFormatter

    init(workout: HKWorkout) {
        self.workout = workout

        chartXAxisFormatter = DateFormatter()
        chartXAxisFormatter.dateFormat = "h:mm a"

        // Go off and fetch the data
        //
        fetchWorkoutHeartRateData { [weak self] error in
            if error != nil {
                self?.errorFetchingWorkoutHRData = true
            }
        }
        fetchWorkoutLocationData { [weak self] error in
            if error != nil {
                self?.errorFetchingRouteData = true
            }
        }
    }

    // MARK: Retry loading data helper methods
    //
    public func retryLoadWorkoutHeartRateData() {
        errorFetchingRouteData = false
        fetchWorkoutHeartRateData { [weak self] error in
            if error != nil {
                self?.errorFetchingWorkoutHRData = true
            }
        }
    }
    public func retryLoadRouteData() {
        errorFetchingWorkoutHRData = false
        fetchWorkoutLocationData { [weak self] error in
            if error != nil {
                self?.errorFetchingRouteData = true
            }
        }
    }
    
    // MARK: Helper methods for fetching related workout data
    //
    private func fetchWorkoutHeartRateData(completion: @escaping (Error?) -> Void) {
        workout.getWorkoutHeartRateData { [weak self] results, error in
            guard error == nil, let heartRateResults = results else {
                completion(error)
                return
            }
            self?.workoutHRData = heartRateResults
        }
    }
    private func fetchWorkoutLocationData(completion: @escaping (Error?) -> Void) {
        workout.getWorkoutLocationData { [weak self] route, error in
            guard error == nil, let routeData = route else {
                completion(error)
                return
            }
            self?.route = routeData
        }
    }

    // MARK: Style related workout informaiton
    //
    var mainColor: Color {
        workout.workoutActivityType.workoutTypeMetadata.mainColor
    }
    var highlightColor: Color {
        workout.workoutActivityType.workoutTypeMetadata.highlightColor
    }
    var iconName: String {
        workout.workoutActivityType.workoutTypeMetadata.systemIconName
    }

    // MARK: Numeric workout values
    //

    // Calories Burned
    //
    private var workoutCalories: Double {
        return workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0
    }
    var numberOfCaloriesBurned: String {
        return String(format: "%.0f cal", workoutCalories)
    }

    // Time
    //
    var workoutTimerDescription: String {
        workout.duration.getTimerStyleActivityDurationString()
    }
    var workoutHoursAndMinutes: String {
        workout.duration.getHoursAndMinutesString()
    }

    // Distance
    //
    var workoutDistanceDescription: String {
        return String(format: "%.2f mi", workout.totalDistance?.doubleValue(for: .mile()) ?? 0)
    }

    // Altitude Data
    //
    var altitudeData: [Double]? {
        guard let route = route, route.count > 0 else {
            return nil
        }
        return route.map { item in
            return item.altitude
        }
    }

    // Velocity Data
    //
    var velocityData: [Double]? {
        guard let route = route, route.count > 0 else {
            return nil
        }
        return route.map { item in
            return item.speed
        }
    }
    
    // MARK: Chart Data
    //

    // X-Axis label data
    //
    var xAxisLabelData: [String]? {
        guard route != nil else {
            return nil
        }
        return [
            chartXAxisFormatter.string(from: route?.first?.timestamp ?? Date()),
            chartXAxisFormatter.string(from: route?.last?.timestamp ?? Date())
        ]
    }

    // HEART RATE DATA
    //
    var simplifiedHRData: [HeartRateReading]? {
        guard workoutHRData != nil else {
            return nil
        }

        // We never want to have more datapoints than we have pixels on the screen / 2?
        //
        let proportion = CGFloat(workoutHRData?.count ?? 0)/(UIScreen.main.bounds.width/CGFloat(4))

        // If the proportion is less than 0, then we know there are fewer data points than there are pixels on the screen
        // so we can go ahead and display all of them. Otherwise, we want to take the division and ROUND DOWN, so that we don't
        // ever try to access an item outside of the array
        //
        var strideAmount = proportion <= 0 ? 1 : Int(proportion.rounded(.down)) // always want to round

        if strideAmount == 0 {
            strideAmount = 1
        }

        let simplifiedData: [HeartRateReading]? = workoutHRData?.indices.compactMap {
            if $0 % strideAmount == 0 { return workoutHRData?[$0] }
            else { return nil }
        }

        return simplifiedData
    }
    
    var maxHeartRate: Int {
        Int(workoutHRData?.map { $0.reading }.max() ?? 0)
    }

    var minHeartRate: Int {
        Int(workoutHRData?.map { $0.reading }.min() ?? 0)
    }

    // SPEED DATA
    //
    var speedData: [Double] {

        let data = route?
            .map { metersPerSecondToMPH(pace: $0.speed) }
            .filter { $0 > 0 } ?? []

        // We never want to have more datapoints than we have pixels on the screen / 2?
        //
        let proportion = CGFloat(data.count)/(UIScreen.main.bounds.width/CGFloat(4))
        
        var strideAmount = proportion <= 0 ? 1 : Int(proportion.rounded(.down)) // always want to round

        if strideAmount == 0 {
            strideAmount = 1
        }

        let simplifiedData: [Double] = data.indices.compactMap {
            if $0 % strideAmount == 0 { return data[$0] }
            else { return nil }
        }

        return simplifiedData
    }
    var averageSpeed: Double {
        getAverageSpeed(segment: route ?? [])
    }
    var mphValue: Double {
        metersPerSecondToMPH(pace: averageSpeed)
    }
    var averagePaceDescription: String {
        "Average Pace: \(String(format: "%.1f", mphValue)) mph - \(getPaceString(route: route ?? []))"
    }
    
    // ELEVATION DATA
    //
    var elevationData: [Double] {
        let elevationData = route?
            .map { metersToFeet(meters: $0.altitude) }
            .filter { $0 > 0 } ?? []
        
        // We never want to have more datapoints than we have pixels on the screen / 2?
        //
        let proportion = CGFloat(elevationData.count)/(UIScreen.main.bounds.width/CGFloat(4))
        
        var strideAmount = proportion <= 0 ? 1 : Int(proportion.rounded(.down)) // always want to round

        if strideAmount == 0 {
            strideAmount = 1
        }

        let simplifiedData: [Double] = elevationData.indices.compactMap {
            if $0 % strideAmount == 0 { return elevationData[$0] }
            else { return nil }
        }

        return simplifiedData
    }
    var netElevationGain: Int {
        Int(getElevation(format: .net, segment: route ?? []))
    }
    var totalGain: Int {
        Int(getElevation(format: .gain, segment: route ?? []))
    }
    var totalLoss: Int {
        Int(getElevation(format: .loss, segment: route ?? []))
    }
}
