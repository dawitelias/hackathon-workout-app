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

        VStack {

            List {

                Section(footer: Text(Strings.footerText)) {

                    ToggleableHeader(text: Strings.dateText, currentValueText: nil, switchValue: $dateRangeFilter.isApplied)

                    if dateRangeFilter.isApplied {

                        DatePicker(
                            selection: $dateRangeFilter.startDate,
                            in: ...(Calendar.current.date(byAdding: .month, value: numberOfMonthsInYear, to: Date()) ?? Date()),
                            displayedComponents: .date) {

                            Text(Strings.fromText)

                        }

                        DatePicker(
                            selection: $dateRangeFilter.endDate,
                            in: ...(Calendar.current.date(byAdding: .month, value: numberOfMonthsInYear, to: Date()) ?? Date()),
                            displayedComponents: .date) {

                            Text(Strings.toText)

                        }

                    }
                    
                }
                
            }
            .navigationBarTitle(Strings.dateText)
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .frame(alignment: .center)

        }.onAppear {

            dateRangeFilter = workoutData.dateRangeFilter

        }.onDisappear {

            workoutData.dateRangeFilter = dateRangeFilter
            workoutData.queryWorkouts()

        }
    }
    
    private let numberOfMonthsInYear = 12
}

// MARK: Assets and Strings
//
extension DateFilter {
    
    private struct Strings {

        static var fromText: String {
            NSLocalizedString("com.okapi.dateFilter.from", value: "From", comment: "Text for selecting initial date.")
        }

        static var toText: String {
            NSLocalizedString("com.okapi.dateFilter.to", value: "To", comment: "Text for selecting end date.")
        }

        static var dateText: String {
            NSLocalizedString("com.okapi.dateFilter.title", value: "Date", comment: "Title for the date filter text.")
        }
        
        static var footerText: String {
            NSLocalizedString("com.okapi.dateFilter.footer", value: "Only show workouts between the selected dates.", comment: "Only show workouts between the selected dates.")
        }

    }
}

// MARK: Previews
//
struct DateFilter_Previews: PreviewProvider {
    static var previews: some View {
        DateFilter().environmentObject(WorkoutData())
    }
}
