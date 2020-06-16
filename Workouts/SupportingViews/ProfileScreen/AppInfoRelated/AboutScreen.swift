//
//  AboutScreen.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/29/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct AboutScreen: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("This project started off as a simple hackathon app - and has been too much fun to stop working on. 🔥🔥🔥")
                    .padding()
                HStack {
                    AboutPageCard(
                        imageName: "emily",
                        fullName: "Emily Cheroske",
                        twitterScreenName: "EmilyCheroske",
                        linkedInProfileID: "emily-cheroske-37476b165")
                        .padding()

                    Spacer()

                    AboutPageCard(
                        imageName: "dawit",
                        fullName: "Dawit Elias",
                        twitterScreenName: "https://twitter.com/da_weet",
                        linkedInProfileID: "https://www.linkedin.com/in/dawitelias/")
                        .padding()
                }
                Spacer()
                VStack {
                    Text("Like our work?")
                        .font(.title)
                        .fontWeight(.bold)
                    Button(action: {
                        let url = URL(string: "itms-apps:itunes.apple.com/us/app/apple-store/id/12345?mt=8&action=write-review")!
                        UIApplication.shared.openURL(url)
                    }) {
                        Text("Let us know by leaving a review! ☕️😃")
                            .font(.headline)
                    }
                    
                }.frame(height: 200).padding()
            }
        }
        .navigationBarTitle("About the Project")
    }
}

struct AboutScreen_Previews: PreviewProvider {
    static var previews: some View {
        AboutScreen()
    }
}
