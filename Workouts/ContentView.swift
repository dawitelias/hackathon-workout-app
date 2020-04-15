//
//  ContentView.swift
//  Workouts
//
//  Created by Dawit Elias on 4/15/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var showFilterView = false
    @State var showProfileView = false
    
    var body: some View {
        NavigationView {
            List {
                // sample layout
                // WorkoutRow can be moved to its own file once we dial it in
                Section(header: Text("April 2020")) {
                    WorkoutRow()
                    WorkoutRow()
                    WorkoutRow()
                }
                Section(header: Text("March 2020")) {
                    WorkoutRow()
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
    }
}

struct WorkoutRow: View {
    var body: some View {
        NavigationLink(destination: Text("hi there")) {
            // existing contents…
            // NavigationLink(destination: ItemDetail(item: item))
            HStack {
                Image(systemName: "person.fill")
                Text("Strength Training")
                Spacer()
                Text("Tuesday")
                    .font(.caption)
                    .foregroundColor(Color.gray)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
