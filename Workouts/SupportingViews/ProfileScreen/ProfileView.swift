//
//  ProfileView.swift
//  Workouts
//
//  Created by Dawit Elias on 4/15/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI
import HealthKit

struct ProfileView: View {
    @EnvironmentObject private var workoutData: WorkoutData
    @Binding var showProfileView: Bool
    @State var selectedChart: Int = 1 // distance chart selected by default
    
    @State var groupedWorkouts: [Date: [HKWorkout]]? = nil
    @State var chartsDateLabels: [String] = [String]()
    @State var timeValues: [Int] = [Int]()
    @State var distanceValues: [Int] = [Int]()
    @State var caloriesValues: [Int] = [Int]()

    var body: some View {

        if self.chartsDateLabels.count == 0 && self.timeValues.count == 0 && self.distanceValues.count == 0 && self.caloriesValues.count == 0 {
            let numMonthsBack = 3

            HealthKitAssistant.getNumWorkoutsPerWeek(numMonthsBack: numMonthsBack) { results, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                let res = results?.sorted(by: { $0.0 < $1.0 })

                var calorieResults = [Date: Double]()
                var distanceResults = [Date: Double]()
                var timeResults = [Date: TimeInterval]()

                let components = Calendar.current.dateComponents([.weekOfYear, .yearForWeekOfYear], from: Calendar.current.date(byAdding: .month, value: -numMonthsBack, to: Date())!)

                if var startDate = Calendar.current.date(from: components) {

                    // We need to increment the start date by 1 week, access the value in the original results and append it to our final results, and if it doesn't exist, we need to add the incremented date with a 0
                    while startDate < Date() {
                        if let theWorkouts = results?[startDate] {
                            calorieResults[startDate] = 0
                            timeResults[startDate] = 0
                            distanceResults[startDate] = 0

                            for i in 0...theWorkouts.count - 1 {
                                calorieResults[startDate]! += theWorkouts[i].totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0.0
                                timeResults[startDate]! += theWorkouts[i].duration
                                distanceResults[startDate]! += theWorkouts[i].totalDistance?.doubleValue(for: .mile()) ?? 0
                            }
                            
                        } else {
                            calorieResults[startDate] = 0
                            distanceResults[startDate] = 0
                            timeResults[startDate] = 0
                        }
                        let newDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: startDate)!
                        let newDateComponents = Calendar.current.dateComponents([.weekOfYear, .yearForWeekOfYear], from: newDate)
                        startDate = Calendar.current.date(from: newDateComponents)!
                    }
                }

                let sortedCals = calorieResults.sorted(by: { $0.key > $1.key }).reversed()
                let sortedDist = distanceResults.sorted(by: { $0.key > $1.key }).reversed()
                let sortedTime = timeResults.sorted(by: { $0.key > $1.key }).reversed()

                self.chartsDateLabels = sortedTime.map { $0.key.weekAbbreviated }
                self.timeValues = sortedTime.map { totalSeconds in
                    return Int(round(totalSeconds.value / 3600.0)) // <- convert to hours
                }
                self.caloriesValues = sortedCals.map { Int(round($0.value)) }
                self.distanceValues = sortedDist.map { Int(round($0.value)) }
            }
        }

        return NavigationView {
            ScrollView {
                if self.chartsDateLabels.count != 0 && self.caloriesValues.count != 0 && self.timeValues.count != 0 && self.distanceValues.count != 0 {
                    if selectedChart == 0 {
                        BarChart(
                            chartTitle: "Weekly Calorie Expenditure (kcal)",
                            unit: "",
                            labels: self.chartsDateLabels,
                            data: self.caloriesValues,
                            startColor: Color("AM_1"),
                            endColor: Color("AM_2")
                        ).frame(height: 270)
                    }
                    if selectedChart == 1 {
                        BarChart(
                            chartTitle: "Weekly Mileage (miles)",
                            unit: "mi",
                            labels: self.chartsDateLabels,
                            data: self.distanceValues,
                            startColor: Color("X_1"),
                            endColor: Color("X_2")
                        ).frame(height: 270)
                    }
                    if selectedChart == 2 {
                        BarChart(
                            chartTitle: "Time spent per week (hours)",
                            unit: "hr",
                            labels: self.chartsDateLabels,
                            data: self.timeValues,
                            startColor: Color("B_1"),
                            endColor: Color("B_2")
                        ).frame(height: 270)
                    }
                    Picker(selection: $selectedChart, label: Text("What is your favorite color?")) {
                        Text("Calories").tag(0)
                        Text("Time").tag(2)
                        Text("Distance").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding([.leading, .trailing])
                } else {
                    Text("Charts Loading...")
                }
                
                // This is for the workouts all time, this month, this week section
                //
                GeometryReader { g in
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Your completed workouts:")
                            .font(.headline)
                            .fontWeight(.light)
                            .padding([.leading, .top])
                            .offset(x: 0, y: 10)
                        HStack {
                            VStack(alignment: .center) {
                                Text("All Time 🔥")
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.01)
                                    .foregroundColor(Color.white)
                                    .padding(.top)
                                    .frame(width: (g.size.width/3), height: nil, alignment: .center)
                                    .fixedSize(horizontal: false, vertical: true)
                                 Text("\(self.workoutData.totalWorkoutsAllTime ?? 0)")
                                    .font(.system(size: 100))
                                    .fontWeight(.heavy)
                                    .minimumScaleFactor(0.01)
                                    .foregroundColor(Color.white)
                                    .padding(.bottom)
                            }
                            .frame(width: (g.size.width/2), height: 140, alignment: .center)
                            .background(LinearGradient(gradient: .init(colors: [Color("X_1"), Color("X_2")]), startPoint: .top, endPoint: .bottom))
                            .cornerRadius(5)
                            .shadow(radius: 1)

                            VStack {
                                VStack(alignment: .center) {
                                    Text("This Month")
                                        .foregroundColor(Color(UIColor.tertiaryLabel))
                                    Text("\(self.workoutData.totalWorkoutsThisMonth ?? 0)")
                                        .font(.title)
                                        .fontWeight(.heavy)
                                        .minimumScaleFactor(0.01)
                                }
                                Spacer()
                                VStack(alignment: .center) {
                                    Text("This Week")
                                        .foregroundColor(Color(UIColor.tertiaryLabel))
                                     Text("\(self.workoutData.totalWorkoutsThisWeek ?? 0)")
                                        .font(.title)
                                        .fontWeight(.heavy)
                                        .minimumScaleFactor(0.01)
                                }
                            }
                            .frame(width: g.size.width/3, height: 120, alignment: .center)
                        }.padding([.top, .leading, .trailing])
                    }
                }

            }
            .navigationBarTitle(Text("Workout History"), displayMode: .large)
            .navigationBarItems(trailing: Button(action: {
                self.showProfileView = false
            }) {
                Text("Done").foregroundColor(Color.pink).bold()
            })
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(showProfileView: .constant(false)).environmentObject(WorkoutData())
            .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
    }
}
