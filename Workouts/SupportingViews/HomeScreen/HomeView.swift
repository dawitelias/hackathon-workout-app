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

    @Environment(\.presentationMode) var presentation

    @EnvironmentObject var workoutData: WorkoutData

    @State var showFilterView = false

    @State var showSettingsView = false

    private var featuredWorkout: HKWorkout? {
        workoutData.mostRecentWorkout
    }

    private var workoutsDoneToday: [HKWorkout] {
        workoutData.workoutsForToday ?? []
    }

    var body: some View {
        
        let empty: [Date: [HKWorkout]] = [:]
        let grouped = workoutData.workouts.reduce(into: empty) { acc, cur in
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
                if workoutsDoneToday.count > 1 {

                    Section(header: Text(Strings.yourWorkouts)) {

                        VStack(alignment: .leading, spacing: nil) {

                            ScrollView(.horizontal, showsIndicators: true) {

                                HStack(alignment: .top, spacing: 20) {
                                    
                                    ForEach(workoutsDoneToday, id: \.self) { workout in

                                        NavigationLink(destination: WorkoutDetail(viewModel: WorkoutDetailViewModel(workout: workout, settings: workoutData.settings))) {

                                            DailyWorkout(workout: workout)

                                        }.buttonStyle(PlainButtonStyle())
                                    }
                                    
                                }.padding(5)
                                
                            }
                            
                            NavigationLink(destination: DailySummary(workouts: workoutsDoneToday).environmentObject(workoutData.settings)) {
                                Text(Strings.viewDailySummary)
                                    .padding()
                            }
                            
                        }
                    }

                } else if featuredWorkout != nil {

                    Section(header: Text(Strings.latestWorkout)) {

                        ZStack {

                            FeaturedWorkout(workout: featuredWorkout!)

                            NavigationLink(destination: WorkoutDetail(viewModel: WorkoutDetailViewModel(workout: featuredWorkout!, settings: workoutData.settings))) {
                                EmptyView()
                            }
                        }
                    }
                }

                // If there ARE active filters, we should show some indication to the users, so that they understand why
                // their list might look different
                //
                if workoutData.appliedFilters.count > 0 || workoutData.activeActivityTypeFilters.count > 0 {

                    Section(header: VStack {

                        Text(Strings.currentlyAppliedFilters)
                            .padding(.all)
                            .font(.subheadline)
                            .frame(width: UIScreen.main.bounds.width, alignment: .leading)

                    }) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .top, spacing: 1) {

                                ForEach(workoutData.activeActivityTypeFilters, id: \.self) { item in
                                    ActivityTypeFilterPill(activityTypeFilter: item)
                                }

                                if workoutData.dateRangeFilter.isApplied {
                                    FilterPill(activityFilter: workoutData.dateRangeFilter)
                                }

                                if workoutData.calorieFilter.isApplied {
                                   FilterPill(activityFilter: workoutData.calorieFilter)
                                }

                                if workoutData.distanceFilter.isApplied {
                                   FilterPill(activityFilter: workoutData.distanceFilter)
                                }

                                if workoutData.durationFilter.isApplied {
                                   FilterPill(activityFilter: workoutData.durationFilter)
                                }
                            }
                        }
                    }
                }

                if sortedDictionaryKeys.count == 0 {

                    Text("Nothing to see here! Either get crackin or check and make sure you've granted us the correct permissions to read your workout data saved in Health Kit.")

                }

                ForEach(sortedDictionaryKeys, id: \.self) { key in

                    Section(header: VStack {

                        Text("\(key.month) \(key.year)")

                    }) {

                        if grouped[key] != nil {

                            ForEach(grouped[key]!, id: \.self) { workout in
                            
                                NavigationLink(destination: WorkoutDetail(viewModel: WorkoutDetailViewModel(workout: workout, settings: workoutData.settings))) {
                                    WorkoutRow(workout: workout)
                                }
                                .padding(.vertical, 8.0)
                            }
                        }
                    }
                }
            }
            .modifier(GroupedListModifier())
            .navigationBarTitle(Text(Strings.workoutsText))
            .navigationBarItems(leading:

                Button(action: {

                    showSettingsView.toggle()

                }) {
                
                    Image(systemName: Images.gear.rawValue).imageScale(.large)
                
                }.sheet(isPresented: $showSettingsView) {
                    
                    SettingsView(showSettings: $showSettingsView).environmentObject(workoutData.settings)

                }, trailing:
                    
                    Button(action: {

                        showFilterView.toggle()

                    }) {

                        Image(systemName: Images.filterIcon.rawValue)
                            .imageScale(.large)

                    }.sheet(isPresented: $showFilterView) {

                        FilterHome(showFilterView: $showFilterView).environmentObject(workoutData)

                    }
            )
        }
        .accentColor(.pink)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
 
            workoutData.queryWorkouts()

        }
    }
}

// MARK: Strings and Assets
//
extension HomeView {

    private enum Images: String {
        case filterIcon = "line.horizontal.3.decrease.circle"
        case gear
    }

    private struct Strings {

        static var workoutsText: String {
            NSLocalizedString("com.okapi.homePage.workouts", value: "Your Workouts", comment: "Workouts")
        }

        static var viewDailySummary: String {
            NSLocalizedString("com.okapi.homePage.viewDailySummary", value: "View Daily Summary", comment: "Text saying view daily sumamry")
        }

        static var currentlyAppliedFilters: String {
            NSLocalizedString("com.okapi.homePage.currentlyAppliedFilters", value: "Currently Applied Filters", comment: "currently applied filters description text")
        }

        static var latestWorkout: String {
            NSLocalizedString("com.okapi.homePage.latestWorkoutText", value: "Your latest workout 🏅", comment: "latest workout text")
        }

        static var yourWorkouts: String {
            NSLocalizedString("com.okapi.homePage.yourWorkouts", value: "Your workouts today 🏅", comment: "Your workouts today text")
        }

    }

}

// MARK: Previews
//
struct HomeView_Previews: PreviewProvider {

    static var previews: some View {

        HomeView().environmentObject(WorkoutData())

    }

}
