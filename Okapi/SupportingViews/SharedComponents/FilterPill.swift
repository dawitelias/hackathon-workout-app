//
//  FilterPill.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/21/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct FilterPill: View {

    @EnvironmentObject private var workoutData: WorkoutData

    var activityFilter: WorkoutFilter

    var body: some View {

        HStack {

            Text(activityFilter.filterDescription)
                .foregroundColor(Color(UIColor.systemBackground))
                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 0))
                .font(.callout)
                .fixedSize(horizontal: false, vertical: true)

            Button(action: {

                self.workoutData.toggleWorkoutFilterApplied(filter: self.activityFilter)

            }) {

                Image(systemName: "xmark")
                    .foregroundColor(Color(UIColor.systemBackground))
                    .imageScale(.medium)

            }
            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 10))

        }
        .background(workoutData.settings.themeColor.color)
        .cornerRadius(15)
        .padding(2)
    }
}

struct FilterPill_Previews: PreviewProvider {
    static var previews: some View {
        FilterPill(activityFilter: ActivityTypeFilter(value: .running, isApplied: true, color: .blue) as! WorkoutFilter).environmentObject(WorkoutData())
    }
}
