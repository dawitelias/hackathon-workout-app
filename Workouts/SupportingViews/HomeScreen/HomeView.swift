//
//  ContentView.swift
//  Workouts
//
//  Created by Dawit Elias on 4/15/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI
import HealthKit

struct HomeView: View {
    @EnvironmentObject var workoutData: WorkoutData

    @Environment(\.presentationMode) var presentation

    @State var showFilterView = false
    @State var showProfileView = false
    
    init() {
        UITableViewHeaderFooterView.appearance().tintColor = UIColor.systemBackground
    }
    
    var body: some View {
        let featuredWorkout = workoutData.featuredWorkout
        let workoutsDoneToday = workoutData.workoutsForToday
        
        let empty: [Date: [HKWorkout]] = [:]
        let grouped = self.workoutData.workouts.reduce(into: empty) { acc, cur in
            let components = Calendar.current.dateComponents([.year, .month], from: cur.startDate)
            let d = Calendar.current.date(from: components)!
            let existing = acc[d] ?? []
            acc[d] = existing + [cur]
        }

        let sortedDictionaryKeys = grouped.map { date in
            return date.key
        }.sorted {
            return $0 > $1
        }
        
        return NavigationView {
            List {
                // If the user has done multiple workouts today, we want to show them a horizontal scroll view of the workouts that
                // they have done, otherwise, if they have only done one workout or they haven't done a workout at all today, then we will
                // fall back to showing the featured workout
                //
                if workoutsDoneToday != nil && workoutsDoneToday!.count > 1 {
                    Section(header: SectionHeader(text: "Your workouts today 🏅")) {
                        VStack(alignment: .leading, spacing: nil) {
                            ScrollView(.horizontal, showsIndicators: true) {
                                HStack(alignment: .top, spacing: 20) {
                                    ForEach(workoutsDoneToday!, id: \.self) { workout in
                                        NavigationLink(destination: WorkoutDetailRevamped(workout: workout)) {
                                            DailyWorkout(workout: workout)
                                        }.buttonStyle(PlainButtonStyle())
                                    }
                                }.padding(5)
                            }
                            NavigationLink(destination: DailySummary(workouts: workoutsDoneToday!)) {
                                Text("View Daily Summary")
                                    .padding()
                            }
                        }
                    }
                } else if featuredWorkout != nil {
                    Section(header: SectionHeader(text: "Your latest workout 🏅")) {
                        ZStack {
                            FeaturedWorkout(workout: featuredWorkout!)
                            NavigationLink(destination: WorkoutDetailRevamped(workout: featuredWorkout!)) {
                                EmptyView()
                            }
                        }
                    }
                }

                // If there ARE active filters, we should show some indication to the users, so that they understand why
                // their list might look different
                //
                if self.workoutData.appliedFilters.count > 0 || self.workoutData.activeActivityTypeFilters.count > 0 {
                    Section(header: VStack {
                        Text("Currently Applied Filters")
                            .padding(.all)
                            .font(.system(size: 21, weight: .medium))
                            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    }) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .top, spacing: 1) {
                                ForEach(self.workoutData.activeActivityTypeFilters, id: \.self) { item in
                                    ActivityTypeFilterPill(activityTypeFilter: item)
                                }
                                if self.workoutData.dateRangeFilter.isApplied {
                                    FilterPill(activityFilter: self.workoutData.dateRangeFilter)
                                }
                                if self.workoutData.calorieFilter.isApplied {
                                   FilterPill(activityFilter: self.workoutData.calorieFilter)
                                }
                                if self.workoutData.distanceFilter.isApplied {
                                   FilterPill(activityFilter: self.workoutData.distanceFilter)
                                }
                                if self.workoutData.durationFilter.isApplied {
                                   FilterPill(activityFilter: self.workoutData.durationFilter)
                                }
                            }
                        }
                    }
                }

                ForEach(sortedDictionaryKeys, id: \.self) { key in
                    Section(header: VStack {
                        Text("\(key.month) \(key.year)")
                            .padding(.all)
                            .font(.system(size: 21, weight: .medium))
                            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    }) {
                        if grouped[key] != nil {
                            ForEach(grouped[key]!, id: \.self) { workout in
                                NavigationLink(destination: WorkoutDetailRevamped(workout: workout)) {
                                    WorkoutRow(workout: workout)
                                }
                                .padding(.vertical, 8.0)
                            }
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle()).environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle(Text("Workouts"))
            .navigationBarItems(leading:
                Button(action: {
                    self.showProfileView.toggle()
                }) {
                    Image(systemName: "chart.bar").imageScale(.large)
                }.sheet(isPresented: $showProfileView) {
                    ProfileView(showProfileView: self.$showProfileView).environmentObject(self.workoutData)
                }, trailing:
                Button(action: {
                    self.showFilterView.toggle()
                }) {
                    Image(systemName: "line.horizontal.3.decrease.circle").imageScale(.large)
                }.sheet(isPresented: $showFilterView) {
                    FilterHome(showFilterView: self.$showFilterView).environmentObject(self.workoutData)
                }
            )
        }
        .accentColor(.pink)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            // Update the view with refreshed data if the user has say, backgrounded the app, gone to do a workout and then
            // re-opened the app. We should also implement a pull down to refresh.
            //
            self.workoutData.queryWorkouts()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(WorkoutData())
    }
}
