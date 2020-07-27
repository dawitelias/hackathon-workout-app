//
//  MapUseInstructions.swift
//  Workouts
//
//  Created by Emily Cheroske on 7/12/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct MapUseInstructions: View {
    var body: some View {
        return ScrollView {
            VStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text("Hello there!")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("It looks like this is your first time using the map, let us show you around!")
                        .font(.callout)
                        .padding(.vertical, 10.0)
                    
                    Text("Selecting Segments")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text("Select a route segment by tapping on any two points on your route. A popup will automatically appear and show you the duration, length and more for this highlighted area. Clear the hightlighted area by closing the popup or tapping anywhere on the map.")
                        .font(.callout)
                }
                
                Image("MapTutorial")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200.0,height:400)
                    .cornerRadius(20)
                    .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
                
                VStack(alignment: .leading) {
                    Text("Sharing")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text("Tap the share icon in the upper right hand corner to share your route or segment with your friends. Make sure to show off your accomplishments! 💪")
                        .font(.callout)
                }
                
                Button(action: {
                    // We need to save this to UserDefaults
                    //
                    UserDefaults.standard.set(false, forKey: "hasUserSeenMap")
                }, label: {
                    Text("Thanks, I'm good!")
                })
            }.padding()
        }
    }
}

struct MapUseInstructions_Previews: PreviewProvider {
    static var previews: some View {
        MapUseInstructions()
    }
}
