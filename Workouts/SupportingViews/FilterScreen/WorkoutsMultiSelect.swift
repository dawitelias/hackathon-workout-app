//
//  MultiSelect.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/21/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct WorkoutsMultiSelect: View {
    @EnvironmentObject var workoutData: WorkoutData

    var body: some View {
        List {
            ForEach(self.workoutData.activityTypeFilters, id: \.self) { item in
                Button(action: {
                    self.workoutData.toggleActivityFilterApplied(filter: item)
                }) {
                    HStack {
                        Text(item.value.workoutTypeMetadata.activityTypeDescription)
                            .foregroundColor(Color(UIColor.label))
                        Spacer()
                        if item.isApplied {
                            Image(systemName: "checkmark")
                                .accentColor(/*@START_MENU_TOKEN@*/.pink/*@END_MENU_TOKEN@*/)
                        }
                    }
                }
            }
        }
        .listStyle(GroupedListStyle()).environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle("Workout Types")
//        .navigationBarItems(trailing: Button(action: {
//            //self.showFilterView = false
//            print("select all/none of workout types")
//        }) {
//            Text("Select All").foregroundColor(Color.pink).bold()
//        })
    }
}

struct MultiSelect_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsMultiSelect().environmentObject(WorkoutData())
    }
}
