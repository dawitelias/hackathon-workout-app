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
            // TODO: WHEN THE APP IS FINISHED ADD IN SCREENSHOTS

//            VStack(alignment: .leading, spacing: nil) {
//                Text("Bringing GIS to your Workouts")
//                    .font(.headline)
//                    .fontWeight(.bold)
//                Text("Explore your workout data in a new way by leveraging the power of GIS.")
//                    .font(.callout)
//                    .fontWeight(.thin)
//                    .frame(height: 50)
//                    .lineLimit(10)
//            }.padding()
//            Image("HighlightedRoute")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 200.0,height:400)
//                .cornerRadius(20)
//                .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
//
//            VStack(alignment: .leading, spacing: nil) {
//                Text("Advanced Filtering")
//                    .font(.headline)
//                    .fontWeight(.bold)
//                Text("Now you can search by distance, calories, duration and more to find that workout you want to show off to your friends.")
//                    .font(.callout)
//                    .fontWeight(.thin)
//                    .frame(height: 100)
//                    .lineLimit(10)
//            }.padding()
//
//            VStack(alignment: .leading, spacing: nil) {
//                Text("Workout History")
//                    .font(.headline)
//                    .fontWeight(.bold)
//                Text("Get a sense of the number of all time workouts you've completed, how many you've done this month, and how the week is going.")
//                    .font(.callout)
//                    .fontWeight(.thin)
//                    .frame(height: 100)
//                    .lineLimit(10)
//            }.padding()
//
//            Image("WorkoutHistory")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 300.0,height:150)
//                .cornerRadius(20)
//                .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
//
//            VStack(alignment: .leading, spacing: nil) {
//                Text("Weekly Stats")
//                    .font(.headline)
//                    .fontWeight(.bold)
//                Text("Get a high level overview of your weekly mileage, calories burned and time spend completing workouts.")
//                    .font(.callout)
//                    .fontWeight(.thin)
//                    .frame(height: 100)
//                    .lineLimit(10)
//            }.padding()
//
//            Image("WeeklyStats")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 300.0,height:150)
//                .cornerRadius(20)
//                .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
//
//            // Designer/developer section
//            //
//            Divider()
//                .padding()
            
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
