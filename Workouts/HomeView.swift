//
//  ContentView.swift
//  Workouts
//
//  Created by Dawit Elias on 4/15/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI
import HealthKit

struct HomeView: View {
    @EnvironmentObject var userData: UserData

    @State var showFilterView = false
    @State var showProfileView = false
    
    init() {
        UITableViewHeaderFooterView.appearance().tintColor = UIColor.systemGray6
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(userData.workoutsGroupedByDate.map { $0.key }, id: \.self) { key in
//                    Section(header: Text(key)) {
                    Section(header: VStack {
                        Text(key)
                            .font(.headline)
                            .padding(.vertical, 8).padding(.horizontal)
                            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    }) {
                        ForEach(self.userData.workoutsGroupedByDate[key] ?? [HKWorkout](), id: \.self) { workout in
                            NavigationLink(destination: WorkoutDetail(workout: workout)) {
                                WorkoutRow(workout: workout)
                            }
                            .padding(.vertical, 8.0)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Workouts"))
            .navigationBarItems(leading:
                Button(action: {
                    self.showProfileView.toggle()
                }) {
                    Image(systemName: "person.circle").imageScale(.large)
                }.sheet(isPresented: $showProfileView) {
                    ProfileView(showProfileView: self.$showProfileView)
                }, trailing:
                Button(action: {
                    self.showFilterView.toggle()
                }) {
                    Image(systemName: "line.horizontal.3.decrease.circle").imageScale(.large)
                }.sheet(isPresented: $showFilterView) {
                    FilterView(showFilterView: self.$showFilterView)
                }
            )
        }
        .accentColor(Color.pink)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(UserData())
    }
}
