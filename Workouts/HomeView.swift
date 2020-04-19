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
    @EnvironmentObject var workoutData: WorkoutData

    @State var showFilterView = false
    @State var showProfileView = false
    
    init() {
        UITableViewHeaderFooterView.appearance().tintColor = UIColor.systemBackground
    }
    
    var body: some View {
        let featuredWorkout = workoutData.featuredWorkout
        
        let groupedWorkouts = Dictionary(grouping: self.workoutData.workouts, by: { ("\($0.startDate.month) \($0.startDate.year)") })
        let sortedDictionaryKeys = groupedWorkouts.map { key, value in
            return key
        }.sorted(by: {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM yyyy"
            guard let dateOne = dateFormatter.date(from: $0), let dateTwo = dateFormatter.date(from: $1) else {
                return true
            }
            
            return dateOne > dateTwo
        })
        
        return NavigationView {
            List {
                if featuredWorkout != nil {
                    Section(header: VStack {
                        Text("Your latest workout 🏅")
                            .padding(.all)
                            .font(.system(size: 21, weight: .medium))
                            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    }) {
                        ZStack {
                            FeaturedWorkout(workout: featuredWorkout!)
                            NavigationLink(destination: WorkoutDetail(workout: featuredWorkout!)) {
                                EmptyView()
                            }
                        }
                    }
                }
                
                ForEach(sortedDictionaryKeys.map { $0 }, id: \.self) { key in
                    Section(header: VStack {
                        Text(key)
                            .padding(.all)
                            .font(.system(size: 21, weight: .medium))
                            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                    }) {
                        if groupedWorkouts[key] != nil {
                            ForEach(groupedWorkouts[key]!, id: \.self) { workout in
                                NavigationLink(destination: WorkoutDetail(workout: workout)) {
                                    WorkoutRow(workout: workout)
                                }
                                .padding(.vertical, 8.0)
                            }
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle()).environment(\.horizontalSizeClass, .regular)
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
                    FilterView(showFilterView: self.$showFilterView).environmentObject(self.workoutData)
                }
            )
        }
        .accentColor(Color.pink)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(WorkoutData())
    }
}
