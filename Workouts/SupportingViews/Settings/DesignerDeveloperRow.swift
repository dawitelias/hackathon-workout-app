//
//  DesignerDeveloperRow.swift
//  Workouts
//
//  Created by Emily Cheroske on 2/8/21.
//  Copyright © 2021 Dawit Elias. All rights reserved.
//

import SwiftUI

struct DesignerDeveloperRow: View {

    @Environment(\.openURL) var openURL

    let imageName: String
    let name: String
    let description: String
    let twitterScreenName: String?
    let linkedInProfileID: String?

    var body: some View {

        HStack {
            
            Image(imageName)
                .resizable()
                .clipShape(Circle())
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .padding(.trailing, 5)
            
            HStack {
                
                VStack(alignment: .leading) {

                    Text(name)
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(Color(UIColor.label))

                    Text(description)
                        .font(.callout)
                        .foregroundColor(Color(UIColor.secondaryLabel))

                }
                
                Spacer()

                if twitterScreenName != nil {

                    Button(action: {

                        openURL(URL(string: "https://twitter.com/\(self.twitterScreenName!)")!)

                    }) {

                        Image("Twitter_Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())

                    }
                    .padding(.trailing, 5)

                }

            }
            
        }

    }

}
