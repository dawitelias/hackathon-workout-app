//
//  RootTabView.swift
//  Okapi
//
//  Created by Emily Cheroske on 2/15/21.
//  Copyright © 2021 Dawit Elias. All rights reserved.
//

import SwiftUI

struct RootTabView: View {
    
    @EnvironmentObject var workoutData: WorkoutData

    var body: some View {

        TabView {

            HomeView()
                .environmentObject(workoutData)
                .tabItem {
                    Label("All Workouts", systemImage: "list.dash")
                }

            DailySummary(workoutData: workoutData)
                .environmentObject(workoutData)
                .tabItem {
                    Label("Daily Summary", systemImage: "calendar")
                }

            SettingsView()
                .environmentObject(workoutData)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .accentColor(workoutData.settings.themeColor.color)
    }
}
