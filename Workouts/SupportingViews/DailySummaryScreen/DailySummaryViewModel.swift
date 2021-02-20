//
//  DailySummaryViewModel.swift
//  Okapi
//
//  Created by Emily Cheroske on 2/15/21.
//  Copyright © 2021 Dawit Elias. All rights reserved.
//

import SwiftUI
import HealthKit

class DailySummaryViewModel: ObservableObject {
    
    private let workoutData: WorkoutData

    @Published var totalCalories: Double = 0
    @Published var totalDistance: Double = 0
    @Published var totalTime: Double = 0
    
    public var todaysWorkouts: [HKWorkout] {

        workoutData.workoutsForToday ?? []

    }
    
    public var timerString: String {

        TimeInterval(exactly: totalTime)?.getHoursAndMinutesString() ?? ""

    }
    
    init(workoutData: WorkoutData) {

        self.workoutData = workoutData

        loadTodaysData()

    }
    
    private func loadTodaysData() {

        var totalCal: Double = 0
        var totalDuration: Double = 0
        var totalDist: Double = 0

        todaysWorkouts.forEach { workout in
            totalCal += workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0
            totalDuration += workout.duration
            totalDist += workout.totalDistance?.doubleValue(for: workoutData.settings.userUnitPreferences == .metric ? .meterUnit(with: .kilo) : .mile()) ?? 0
        }
        
        totalCalories = totalCal
        totalTime = totalDuration
        totalDistance = totalDist

    }
}
