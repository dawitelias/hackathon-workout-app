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
        ScrollView(.vertical, showsIndicators: false) {
 
            VStack {
                Text("Designed By:")
                    .font(.title)
                    .fontWeight(.bold)
                AboutPageCard(
                    imageName: "dawit",
                    fullName: "Dawit Elias",
                    twitterScreenName: "https://twitter.com/da_weet",
                    linkedInProfileID: "https://www.linkedin.com/in/dawitelias/")
                    .padding()
                
                Text("Developed By:")
                    .font(.title)
                    .fontWeight(.bold)
                AboutPageCard(
                    imageName: "emily",
                    fullName: "Emily Cheroske",
                    twitterScreenName: "EmilyCheroske",
                    linkedInProfileID: "emily-cheroske-37476b165")
                    .padding()
                
                Spacer()
                Text("Like our work?")
                    .font(.title)
                    .fontWeight(.bold)

                VStack(alignment: .center) {
                    Button(action: {
                        let url = URL(string: "https://itunes.apple.com/app/id\(1514974211)?action=write-review")!
                        UIApplication.shared.openURL(url)
                    }) {
                        Text("Leave us a review!")
                            .font(.headline)
                    }
                        .foregroundColor(.white)
                        .font(.title)
                        .padding()
                        .cornerRadius(5)
                        .border(Color(UIColor.label), width: 5)
                }.padding(10)
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
