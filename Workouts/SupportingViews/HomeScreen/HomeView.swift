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
        
        let groupedWorkouts = Dictionary(grouping: self.workoutData.workouts, by: { ("\($0.startDate.month) \($0.startDate.year)") })
        let sortedDictionaryKeys = groupedWorkouts.map { key, value in
            return key
        }.sorted(by: {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM yyyy"
            guard let dateOne = dateFormatter.date(from: $0), let dateTwo = dateFormatter.date(from: $1) else {
                return true
            }
            
            return dateOne > dateTwo
        })
        
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
                if self.workoutData.appliedFilters.count > 0 {
                    Section(header: VStack {
                        Text("Currently Applied Filters")
                            .padding(.all)
                            .font(.system(size: 21, weight: .medium))
                            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    }) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .top, spacing: 1) {
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

                ForEach(sortedDictionaryKeys.map { $0 }, id: \.self) { key in
                    Section(header: VStack {
                        Text(key)
                            .padding(.all)
                            .font(.system(size: 21, weight: .medium))
                            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    }) {
                        if groupedWorkouts[key] != nil {
                            ForEach(groupedWorkouts[key]!, id: \.self) { workout in
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
                    Image(systemName: "person.circle").imageScale(.large)
                }.sheet(isPresented: $showProfileView) {
                    ProfileView(showProfileView: self.$showProfileView)
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(WorkoutData())
    }
}
