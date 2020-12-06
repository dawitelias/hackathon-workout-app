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

            ForEach(workoutData.activityTypeFilters, id: \.self) { item in

                Button(action: {

                    workoutData.toggleActivityFilterApplied(filter: item)

                }) {

                    HStack {

                        Text(item.value.workoutTypeMetadata.activityTypeDescription)
                            .foregroundColor(Color(UIColor.label))

                        Spacer()

                        if item.isApplied {

                            Image(systemName: Images.checkmark)
                                .accentColor(/*@START_MENU_TOKEN@*/.pink/*@END_MENU_TOKEN@*/)

                        }

                    }

                }

            }

        }
        .modifier(GroupedListModifier())
        .navigationBarTitle(Strings.workoutTypes)
    }

}

// MARK: Assets and Strings
//
extension WorkoutsMultiSelect {
    
    private enum Images: String {
        case checkmark
    }
    
    private struct Strings {
        
        static var workoutTypes: String {
            NSLocalizedString("com.okapi.workoutsMultiSelect.title", value: "Workout Types", comment: "Title for modal allowing user to select multiple types of workouts")
        }
    }

}

// MARK: Previews
//
struct WorkoutsMultiSelect_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsMultiSelect().environmentObject(WorkoutData())
    }
}
