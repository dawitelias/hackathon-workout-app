//
//  WorkoutHistoryViewModel.swift
//  Workouts
//
//  Created by Emily Cheroske on 11/14/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import Foundation

class WorkoutHistoryViewModel: ObservableObject {

    // MARK: Published properties
    //
    @Published var dailyCaloriesData: [(String, Int)]? = nil

    @Published var dailyWorkoutDurationData: [(String, Int)]? = nil

    @Published var dailyWorkoutDistanceData: [(String, Int)]? = nil

    @Published var allTimeCompletedWorkouts: Int? = nil

    @Published var workoutsCompletedThisMonth: Int = 10

    @Published var workoutsCompletedThisWeek: Int = 20

    init() {
        // Load workout simple data
        //
        loadNumberOfAllTimeWorkouts()
        loadWorkoutsCompletedThisWeek()
        loadNumberOfWorkoutsThisMonth()

        // Load chart data
        //
        loadCaloriesData()
        loadWorkoutDurationData()
        loadWorkoutDistanceData()
    }

    // MARK: Data loader helpers
    //
    private func loadNumberOfAllTimeWorkouts() {
        allTimeCompletedWorkouts = 10
    }
    
    private func loadNumberOfWorkoutsThisMonth() {
        workoutsCompletedThisMonth = 5
    }

    private func loadWorkoutsCompletedThisWeek() {
        workoutsCompletedThisWeek = 2
    }

    private func loadCaloriesData() {
        // TODO: populate with real calories data
        //
        dailyCaloriesData = [
            ("11/8", 1000),
            ("11/9", 2000),
            ("11/10", 800),
            ("11/11", 700),
            ("11/12", 500),
            ("11/13", 600)
        ]
    }

    private func loadWorkoutDurationData() {
        // TODO: populate with real duration data
        //
        dailyWorkoutDurationData = [
            ("11/8", 50),
            ("11/9", 10),
            ("11/10", 50),
            ("11/11", 45),
            ("11/12", 20),
            ("11/13", 30)
        ]
    }

    private func loadWorkoutDistanceData() {
        // TODO: populate with real data
        //
        dailyWorkoutDistanceData = [
            ("11/8", 8),
            ("11/9", 7),
            ("11/10", 6),
            ("11/11", 2),
            ("11/12", 10),
            ("11/13", 3)
        ]
    }
}
