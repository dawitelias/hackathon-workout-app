//
//  MultiSelect.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/21/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct MultiSelect: View {
    @EnvironmentObject var workoutData: WorkoutData

    var body: some View {
        List {
            ForEach(self.workoutData.activityTypeFilters, id: \.self) { item in
                Button(action: {
                    self.workoutData.toggleActivityFilterApplied(filter: item)
                }) {
                    HStack {
                        Text(item.value.workoutTypeMetadata.activityTypeDescription)
                        Spacer()
                        if item.isApplied {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        }
    }
}

struct MultiSelect_Previews: PreviewProvider {
    static var previews: some View {
        MultiSelect().environmentObject(WorkoutData())
    }
}
