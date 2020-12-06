//
//  SettingsView.swift
//  Workouts
//
//  Created by Emily Cheroske on 12/5/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct SettingsView: View {

    var body: some View {
        
        VStack {
            Text("Settings View!")
        }
    }

}

// TODO: These used to live under filters, incorporate into this view instead
//                Section(header: SectionHeader(text: "App Info")) {
//                    NavigationLink(destination: AboutScreen()) {
//                        Text("About")
//                    }
//                    NavigationLink(destination: Feedback()) {
//                        Text("Feedback")
//                    }
//                    NavigationLink(destination: Licensing()) {
//                        Text("Acknowledgements")
//                    }
//                }

// MARK: Previews
//
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
