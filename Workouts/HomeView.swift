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
        UITableViewHeaderFooterView.appearance().tintColor = UIColor.systemBackground
    }
    
    var body: some View {
        let featuredWorkout = userData.featuredWorkout // MARK: TODO <-- Emily come back to this
        
        return NavigationView {
            List {
                if featuredWorkout != nil {
                    NavigationLink(destination: WorkoutDetail(workout: featuredWorkout!)) {
                        VStack(alignment: .leading) {
                            Text("Your latest workout 🏅")
                                .padding(.vertical)
                                .font(.system(size: 21, weight: .medium))
                            FeaturedWorkout(workout: featuredWorkout!)
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        }
                    }.padding(.trailing, -22.0) // <-- hide that dang little arrow icon
                }
                
                ForEach(userData.workoutsGroupedByDate.map { $0.key }, id: \.self) { key in
                    Section(header: VStack {
                        Text(key)
                            .padding(.all)
                            .font(.system(size: 21, weight: .medium))
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
                    FilterView(showFilterView: self.$showFilterView).environmentObject(self.userData)
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
