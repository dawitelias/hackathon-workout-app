//
//  ProfileView.swift
//  Workouts
//
//  Created by Dawit Elias on 4/15/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    
    @Binding var showProfileView: Bool

    var body: some View {
        NavigationView {
            List {
                Section(header: EmptyView()) {
                    Text("Profile information coming soon...")
//                    NavigationLink(destination: HealthInfoScreen()) {
//                        Text("Health Info")
//                    }
//                    NavigationLink(destination: WeeklySummary()) {
//                        Text("Weekly Summary")
//                    }
//                    NavigationLink(destination: Badges()) {
//                        Text("Badges")
//                    }
                }
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
            .navigationBarTitle(Text("Profile"), displayMode: .large)
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
        ProfileView(showProfileView: .constant(false))
    }
}
