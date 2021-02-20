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
                
                // TODO: Add back in the featured workout someday.

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

                    Text("Hmmmm, looks like we aren't finding any data. 🤔")

                }
//                
//                Button(action: {
//                    WorkoutDataHelper.populateEachActivityType()
//                }, label: {
//                    Text("Backfill with test data")
//                })

                ForEach(sortedDictionaryKeys, id: \.self) { key in

                    Section(header: VStack {

                        Text("\(key.month) \(key.year)")

                    }) {

                        if grouped[key] != nil {

                            ForEach(grouped[key]!, id: \.self) { workout in
                            
                                NavigationLink(destination: WorkoutDetail(viewModel: WorkoutDetailViewModel(workout: workout, settings: workoutData.settings))) {
                                    WorkoutRow(workout: workout, color: workoutData.settings.themeColor.color)
                                }
                                .padding(.vertical, 8.0)
                            }
                        }
                    }
                }
            }
            .modifier(GroupedListModifier())
            .navigationBarTitle(Text(Strings.workoutsText))
            .navigationBarItems(leading: EmptyView() , trailing:
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
        .accentColor(workoutData.settings.themeColor.color)
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
