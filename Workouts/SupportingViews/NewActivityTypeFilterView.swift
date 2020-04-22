//
//  NewActivityTypeFilterView.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/21/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct NewActivityTypeFilterView: View {
    @EnvironmentObject var workoutData: WorkoutData
    
    @State private var selection: Int? = nil
    
    var body: some View {
        HStack {
            Text("Workout Types")
                .padding(.top, 20)
                .padding(.bottom, 5)
                .font(.system(size: 21, weight: .medium))

            NavigationLink(destination: MultiSelect().environmentObject(self.workoutData), tag: 1, selection: $selection) {
                Button(action: {
                    self.selection = 1
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .foregroundColor(.blue)
                        .imageScale(.large)
                        .frame(width: 25, height: 25, alignment: .center)
                        .padding(.trailing, 10)
                        .padding(.leading, 10)
                        .padding(.top, 20)
                        .padding(.bottom, 5)
                }
            }
        }
    }
}

struct NewActivityTypeFilterView_Previews: PreviewProvider {
    static var previews: some View {
        NewActivityTypeFilterView()
            .environmentObject(WorkoutData())
    }
}
