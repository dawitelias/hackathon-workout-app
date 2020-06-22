//
//  ProfileView.swift
//  Workouts
//
//  Created by Dawit Elias on 4/15/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI
import HealthKit

struct ProfileView: View {
    @EnvironmentObject private var workoutData: WorkoutData
    @Binding var showProfileView: Bool

    var body: some View {

        return NavigationView {
            VStack {
                CommitStyleChart()
                    .padding(.top, 20)

                HStack {
                    VStack(alignment: .leading) {
                        Text("All Time")
                        Text("\(workoutData.totalWorkoutsAllTime ?? 0)")
                            .font(.title)
                            .fontWeight(.heavy)
                            .minimumScaleFactor(0.01)
                            .foregroundColor(Color.pink)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("This Month")
                        Text("\(workoutData.totalWorkoutsThisMonth ?? 0)")
                            .font(.title)
                            .fontWeight(.heavy)
                            .minimumScaleFactor(0.01)
                            .foregroundColor(Color.pink)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("This Week")
                        Text("\(workoutData.totalWorkoutsThisWeek ?? 0)")
                            .font(.title)
                            .fontWeight(.heavy)
                            .minimumScaleFactor(0.01)
                            .foregroundColor(Color.pink)
                    }
                }
                .padding([.trailing, .leading], 30)
                .padding(.top, 20)
                List {
                    Section(header: SectionHeader(text: "App Info")) {
                        NavigationLink(destination: AboutScreen()) {
                            Text("About")
                        }
                        NavigationLink(destination: Feedback()) {
                            Text("Feedback")
                        }
                    }
                }
                .listStyle(GroupedListStyle()).environment(\.horizontalSizeClass, .regular)
            }
            .navigationBarTitle(Text("Workout History"), displayMode: .large)
            .navigationBarItems(trailing: Button(action: {
                self.showProfileView = false
            }) {
                Text("Done").foregroundColor(Color.pink).bold()
            })
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(showProfileView: .constant(false)).environmentObject(WorkoutData())
    }
}
