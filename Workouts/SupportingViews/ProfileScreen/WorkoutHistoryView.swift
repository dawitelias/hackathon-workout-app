//
//  WorkoutHistoryView.swift
//  Workouts
//
//  Created by Emily Cheroske on 11/14/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct WorkoutHistoryView: View {

    @ObservedObject var viewModel: WorkoutHistoryViewModel

    @Binding var showProfileView: Bool

    var body: some View {

        NavigationView {

            ScrollView {

                VStack {

                    // MARK: Weekly Mileage Chart
                    //
                    if viewModel.dailyWorkoutDistanceData != nil {

                        BarChartView(
                            data: ChartData(values: viewModel.dailyWorkoutDistanceData!),
                            title: "Weekly Mileage",
                            legend: "Total: \(100) miles",
                            form: ChartForm.extraLarge,
                            dropShadow: false)
                            .padding(.horizontal)

                    } else {
                        Text("Your mileage is loading.")
                            .font(.headline)
                    }
                    
                    HStack {

                        // MARK: Weekly Calorie Burn Chart
                        //
                        if viewModel.dailyCaloriesData != nil {

                            BarChartView(
                                data: ChartData(values: viewModel.dailyCaloriesData!),
                                title: "Weekly Calories 🔥",
                                legend: "Average \(10) kcal per day",
                                form: ChartForm.medium,
                                dropShadow: false)

                        } else {
                            Text("Your weekly calorie data is loading.")
                                .font(.headline)
                        }

                        // MARK: Weekly Time Spent Working Out Chart
                        //
                        if viewModel.dailyWorkoutDurationData != nil {

                            BarChartView(
                                data: ChartData(values: viewModel.dailyWorkoutDurationData!),
                                title: "Duration",
                                legend: "Weekly total: \(10) hr",
                                form: ChartForm.medium,
                                dropShadow: false)

                        } else {

                            Text("Your time is loading.")
                                .font(.headline)

                        }
                        
                    }.padding(.horizontal)
                }
            }
            .navigationBarTitle(Text("Weekly Overview"), displayMode: .large)
            .navigationBarItems(trailing: Button(action: {
                self.showProfileView = false
            }) {
                Text("Done").foregroundColor(Color.pink).bold()
            })
        }
    }
    
    let chartHeight: CGFloat = 270
}

struct WorkoutHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutHistoryView(viewModel: WorkoutHistoryViewModel(), showProfileView: .constant(false))
    }
}
