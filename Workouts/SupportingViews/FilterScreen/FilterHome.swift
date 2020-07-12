//
//  FilterHome.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/25/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct FilterHome: View {
    @EnvironmentObject var workoutData: WorkoutData
    @Binding var showFilterView: Bool
    
    var body: some View {
        var workoutsIndicationText = "Multiple"
        if self.workoutData.activeActivityTypeFilters.count == 0 {
            workoutsIndicationText = "None"
        } else if self.workoutData.activeActivityTypeFilters.count == 1 {
            workoutsIndicationText = self.workoutData.activeActivityTypeFilters[0].value.workoutTypeMetadata.activityTypeDescription
        }

        return NavigationView {
            List {
                Section {
                    NavigationLink(destination: WorkoutsMultiSelect().environmentObject(workoutData)) {
                        HStack {
                            Text("Workouts")
                            Spacer()
                            Text(workoutsIndicationText)
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                        }
                    }
                }
                Section {
                    NavigationLink(destination: DateFilter().environmentObject(workoutData)) {
                        HStack {
                            Text("Date")
                            Spacer()
                            Text(self.workoutData.dateRangeFilter.isApplied ? "On" : "Off")
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                        }
                    }
                    NavigationLink(destination: DistanceFilter().environmentObject(workoutData)) {
                        HStack {
                            Text("Distance")
                            Spacer()
                            Text(self.workoutData.distanceFilter.isApplied ? "On" : "Off")
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                        }
                    }
                    NavigationLink(destination: DurationFilter().environmentObject(workoutData)) {
                        HStack {
                            Text("Duration")
                            Spacer()
                            Text(self.workoutData.durationFilter.isApplied ? "On" : "Off")
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                        }
                    }
                    NavigationLink(destination: CaloriesFilter().environmentObject(workoutData)) {
                        HStack {
                            Text("Calories Burned")
                            Spacer()
                            Text(self.workoutData.calorieFilter.isApplied ? "On" : "Off")
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                        }
                    }
                }
                Section {
                    Button(action: {
                        self.workoutData.distanceFilter.isApplied = false
                        self.workoutData.durationFilter.isApplied = false
                        self.workoutData.calorieFilter.isApplied = false
                        self.workoutData.dateRangeFilter.isApplied = false
                        self.workoutData.activeActivityTypeFilters.forEach { filter in
                            self.workoutData.toggleActivityFilterApplied(filter: filter)
                        }
                        self.workoutData.queryWorkouts()
                    }) {
                        Text("Clear all filters")
                            .foregroundColor(Color.pink)
                    }
                }
                
                Section(header: SectionHeader(text: "App Info")) {
                    NavigationLink(destination: AboutScreen()) {
                        Text("About")
                    }
                    NavigationLink(destination: Feedback()) {
                        Text("Feedback")
                    }
                }
                
            }.listStyle(GroupedListStyle()).environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle(Text("Filters"), displayMode: .large)
            .navigationBarItems(trailing: Button(action: {
                self.showFilterView = false
            }) {
                Text("Done").foregroundColor(Color.pink).bold()
            })
        }
    }
}

struct FilterHome_Previews: PreviewProvider {
    static var previews: some View {
        FilterHome(showFilterView: .constant(true)).environmentObject(WorkoutData())
    }
}
