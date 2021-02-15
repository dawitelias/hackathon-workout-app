//
//  ActivityTypeFilterPill.swift
//  Workouts
//
//  Created by Emily Cheroske on 6/2/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct ActivityTypeFilterPill: View {

    @EnvironmentObject private var workoutData: WorkoutData

    var activityTypeFilter: ActivityTypeFilter

    var body: some View {

        HStack {

            Text(activityTypeFilter.value.workoutTypeMetadata.activityTypeDescription)
                .foregroundColor(Color(UIColor.systemBackground))
                .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 0))
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)

            Button(action: {

                workoutData.toggleActivityFilterApplied(filter: activityTypeFilter)

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

// MARK: Previews
//
struct ActivityTypeFilterPill_Previews: PreviewProvider {
    static var previews: some View {
        ActivityTypeFilterPill(activityTypeFilter: ActivityTypeFilter(value: .running, isApplied: true, color: .red))
    }
}
