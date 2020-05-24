//
//  AboutPageCard.swift
//  Workouts
//
//  Created by Emily Cheroske on 5/24/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI
import UIKit

struct AboutPageCard: View {
    var imageName: String
    var fullName: String
    var twitterScreenName: String
    var linkedInProfileID: String
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .clipShape(Circle())
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
            VStack(alignment: .leading) {
                Text(fullName)
                    .font(.headline)
                    .fontWeight(.heavy)
                HStack {
                    Button(action: {
                        let application = UIApplication.shared
                        
                        if let url = URL(string: "https://twitter.com/\(self.twitterScreenName)"), application.canOpenURL(url) {
                            application.open(url as URL)
                        } else {
                            // ALERT the user that they can't open the URL
                        }
                    }) {
                        Image("Twitter_Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                    }.padding(.trailing, 5)

                    Button(action: {
                        let application = UIApplication.shared
                        
                        // If you have the linked in app installed on your phone this will open in app instead
                        // of through the browser
                        //
                        if let url = URL(string: "https://www.linkedin.com/in/\(self.linkedInProfileID)"), application.canOpenURL(url) {
                            application.open(url as URL)
                        } else {
                            // ALERT the user that they can't open the URL
                        }
                    }) {
                        Image("LinkedIn_Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                    }.padding(.leading, 5)
                }
            }//.offset(y: -30)
        }
    }
}

struct AboutPageCard_Previews: PreviewProvider {
    static var previews: some View {
        AboutPageCard(
            imageName: "emily",
            fullName: "Emily Cheroske",
            twitterScreenName: "EmilyCheroske",
            linkedInProfileID: "emily-cheroske-37476b165")
    }
}
