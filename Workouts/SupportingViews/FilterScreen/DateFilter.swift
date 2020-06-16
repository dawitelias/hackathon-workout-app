//
//  DateFilter.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/25/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct DateFilter: View {
    @EnvironmentObject var workoutData: WorkoutData
    @State private var dateRangeFilter = DateRangeWorkoutFilter(startDate: Date(), endDate: Date(), isApplied: false)

    var body: some View {
        return VStack {
            List {
                Section(footer: Text("Only show workouts between the selected dates.")) {
                    ToggleableHeader(text: "Date", currentValueText: nil, switchValue: $dateRangeFilter.isApplied)
                    if dateRangeFilter.isApplied {
                        DatePicker(selection: $dateRangeFilter.startDate, in: ...(Calendar.current.date(byAdding: .month, value: 12, to: Date()) ?? Date()), displayedComponents: .date) {
                            Text("From")
                        }
                        DatePicker(selection: $dateRangeFilter.endDate, in: ...(Calendar.current.date(byAdding: .month, value: 12, to: Date()) ?? Date()), displayedComponents: .date) {
                            Text("To")
                        }
                    }
                }
                
            }
            .navigationBarTitle("Date")
            .listStyle(GroupedListStyle()).environment(\.horizontalSizeClass, .regular).frame(width: nil, height: nil, alignment: .center)
        }.onAppear {
            self.dateRangeFilter = self.workoutData.dateRangeFilter
        }.onDisappear {
            self.workoutData.dateRangeFilter = self.dateRangeFilter
            self.workoutData.queryWorkouts()
        }
    }
}

struct DateFilter_Previews: PreviewProvider {
    static var previews: some View {
        DateFilter().environmentObject(WorkoutData())
    }
}
