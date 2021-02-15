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

        var workoutsIndicationText = Strings.multipleWorkoutsSelected

        if workoutData.activeActivityTypeFilters.count == 0 {

            workoutsIndicationText = Strings.noWorkoutsSelected

        } else if workoutData.activeActivityTypeFilters.count == 1 {

            workoutsIndicationText = workoutData.activeActivityTypeFilters[0].value.workoutTypeMetadata.activityTypeDescription

        }

        return NavigationView {

            List {

                Section {

                    NavigationLink(destination: WorkoutsMultiSelect().environmentObject(workoutData)) {

                        HStack {

                            Text(Strings.activityTypes)
                                .fontWeight(.light)

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

                            Text(Strings.dateRange)
                                .fontWeight(.light)

                            Spacer()

                            Text(workoutData.dateRangeFilter.isApplied ? Strings.onText : Strings.offText)
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                        }
                    }

                    NavigationLink(destination: DistanceFilter().environmentObject(workoutData)) {

                        HStack {

                            Text(Strings.distanceString)
                                .fontWeight(.light)

                            Spacer()

                            Text(workoutData.distanceFilter.isApplied ? Strings.onText : Strings.offText)
                                .font(.footnote)
                                .foregroundColor(Color.gray)

                        }

                    }

                    NavigationLink(destination: DurationFilter().environmentObject(workoutData)) {

                        HStack {

                            Text(Strings.durationString)
                                .fontWeight(.light)

                            Spacer()

                            Text(workoutData.durationFilter.isApplied ? Strings.onText : Strings.offText)
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                        }
                    }
                    NavigationLink(destination: CaloriesFilter().environmentObject(workoutData)) {
                        HStack {
                            Text(Strings.caloriesBurnedString)
                                .fontWeight(.light)
                            Spacer()
                            Text(workoutData.calorieFilter.isApplied ? Strings.onText : Strings.offText)
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                        }
                    }
                }
                Section {

                    Button(action: {

                        workoutData.distanceFilter.isApplied = false
                        workoutData.durationFilter.isApplied = false
                        workoutData.calorieFilter.isApplied = false
                        workoutData.dateRangeFilter.isApplied = false

                        workoutData.activeActivityTypeFilters.forEach { filter in
                            workoutData.toggleActivityFilterApplied(filter: filter)
                        }

                        workoutData.queryWorkouts()

                    }) {

                        Text(Strings.clearFiltersText).foregroundColor(workoutData.settings.themeColor.color)

                    }
                }
            }
            .modifier(GroupedListModifier())
            .navigationBarTitle(Text(Strings.filtersText), displayMode: .large)
            .navigationBarItems(trailing: Button(action: {

                showFilterView = false

            }) {

                Text(Strings.doneText).foregroundColor(workoutData.settings.themeColor.color).bold()

            })
        }
    }
}

// MARK: Assets and strings
//
extension FilterHome {

    private struct Strings {

        static var filtersText: String {
            NSLocalizedString("com.okapi.filterPage.filtersText", value: "Filters", comment: "Title for the filters page.")
        }

        static var onText: String {
            NSLocalizedString("com.okapi.filterPage.onText", value: "On", comment: "Text for actively applied filter.")
        }

        static var offText: String {
            NSLocalizedString("com.okapi.filterPage.offText", value: "Off", comment: "Text for non-active filter.")
        }

        static var doneText: String {
            NSLocalizedString("com.okapi.filterPage.doneText", value: "Done", comment: "Done.")
        }

        static var clearFiltersText: String {
            NSLocalizedString("com.okapi.filterPage.clearAllFilters", value: "Clear all filters", comment: "Text telling user to clear their currently applied filters.")
        }

        static var caloriesBurnedString: String {
            NSLocalizedString("com.okapi.filterPage.caloriesFilter", value: "Calories Burned", comment: "Calories burned filter text.")
        }

        static var durationString: String {
            NSLocalizedString("com.okapi.filterPage.durationFilter", value: "Duration", comment: "Duration filter text.")
        }

        static var distanceString: String {
            NSLocalizedString("com.okapi.filterPage.distanceFilter", value: "Distance", comment: "Distance filter text.")
        }

        static var dateRange: String {
            NSLocalizedString("com.okapi.filterPage.dateRange", value: "Date Range", comment: "Date rage filter text.")
        }

        static var activityTypes: String {
            NSLocalizedString("com.okapi.filterPage.activityTypes", value: "Activity Types", comment: "Activity Types filter text.")
        }

        static var multipleWorkoutsSelected: String {
            NSLocalizedString("com.okapi.filterPage.multipleWorkoutsSelected", value: "Multiple", comment: "Text showing that multiple workout filters have been selected.")
        }

        static var noWorkoutsSelected: String {
            NSLocalizedString("com.okapi.filterPage.noWorkoutsSelected", value: "None", comment: "Text showing that no workouts were selected.")
        }
    }
}

// MARK: Previews
//
struct FilterHome_Previews: PreviewProvider {
    static var previews: some View {
        FilterHome(showFilterView: .constant(true)).environmentObject(WorkoutData())
    }
}
