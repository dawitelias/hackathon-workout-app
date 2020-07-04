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
    @State var selectedChart: Int = 2

    var body: some View {

        return NavigationView {
            ScrollView {
                if selectedChart == 0 {
                    BarChart(
                        chartTitle: "Weekly Calorie Expenditure (kcal)",
                        labels: [
                            "Sat", "Sun", "Mon", "Tues", "Thu", "Fri", "Sat", "Sat", "Sun", "Mon", "Tues", "Thu", "Fri", "Sat"
                        ],
                        data: [
                            10, 80, 40, 20, 80, 60, 30, 10, 80, 40, 20, 80, 60, 30
                        ],
                        startColor: .blue,
                        endColor: .purple
                    ).frame(height: 200).padding()
                }
                if selectedChart == 1 {
                    BarChart(
                        chartTitle: "Weekly Mileage (miles)",
                        labels: [
                            "Sat", "Sun", "Mon", "Tues", "Thu", "Fri", "Sat", "Sat", "Sun", "Mon", "Tues", "Thu", "Fri", "Sat"
                        ],
                        data: [
                            10, 80, 40, 20, 80, 60, 30, 10, 80, 40, 20, 80, 60, 30
                        ],
                        startColor: .green,
                        endColor: .purple
                    ).frame(height: 200).padding()
                }
                if selectedChart == 2 {
                    BarChart(
                        chartTitle: "Time spent per week (hours)",
                        labels: [
                            "Sat", "Sun", "Mon", "Tues", "Thu", "Fri", "Sat", "Sat", "Sun", "Mon", "Tues", "Thu", "Fri", "Sat"
                        ],
                        data: [
                            10, 80, 40, 20, 80, 60, 30, 10, 80, 40, 20, 80, 60, 30
                        ],
                        startColor: .pink,
                        endColor: .purple
                    ).frame(height: 200).padding()
                }
                Picker(selection: $selectedChart, label: Text("What is your favorite color?")) {
                    Text("Calories").tag(0)
                    Text("Time").tag(1)
                    Text("Distance").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding([.leading, .trailing])

                Divider()

                HStack {
                    VStack(alignment: .center) {
                        Text("All Time")
                            .foregroundColor(Color.white)
                            .padding([.leading,.trailing,.top])
                        Text("\(workoutData.totalWorkoutsAllTime ?? 0)")
                            .font(.title)
                            .fontWeight(.heavy)
                            .minimumScaleFactor(0.01)
                            .foregroundColor(Color.white)
                            .padding(.bottom)
                    }.background(Color.pink)
                    VStack {
                        VStack(alignment: .leading) {
                            Text("This Month")
                            Text("\(workoutData.totalWorkoutsThisMonth ?? 0)")
                                .font(.title)
                                .fontWeight(.heavy)
                                .minimumScaleFactor(0.01)
                                .foregroundColor(Color.pink)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("This Week")
                            Text("\(workoutData.totalWorkoutsThisWeek ?? 0)")
                                .font(.title)
                                .fontWeight(.heavy)
                                .minimumScaleFactor(0.01)
                                .foregroundColor(Color.pink)
                        }
                    }
                    
                }
                .padding([.trailing, .leading], 30)
                .padding(.top, 20)

                Section(header: SectionHeader(text: "App Info")) {
                    NavigationLink(destination: AboutScreen()) {
                        Text("About")
                    }
                    NavigationLink(destination: Feedback()) {
                        Text("Feedback")
                    }
                }
//                List {
//                    Section(header: SectionHeader(text: "App Info")) {
//                        NavigationLink(destination: AboutScreen()) {
//                            Text("About")
//                        }
//                        NavigationLink(destination: Feedback()) {
//                            Text("Feedback")
//                        }
//                    }
//                }
//                .listStyle(GroupedListStyle()).environment(\.horizontalSizeClass, .regular)
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
