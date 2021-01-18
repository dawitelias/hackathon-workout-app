//
//  MenuViewContent.swift
//  Workouts
//
//  Created by Emily Cheroske on 12/20/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct MenuViewContent: View {

    @Binding var showSettings: Bool

    var body: some View {

        ZStack {

//            Image("LandingPageImage")
//                .resizable()
//                .edgesIgnoringSafeArea(.all)

            VStack {

                VStack(alignment: .center, spacing: 20) {

                    Image(Assets.logo.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)

                    NavigationLink(destination: AboutScreen()) {
                        Text(Strings.about)
                    }

                    NavigationLink(destination: Feedback()) {
                        Text(Strings.feedback)
                    }

                    Spacer()

                }
                //.foregroundColor(.clear).background(Color.clear)

            }
            .padding()
            //.foregroundColor(.clear).background(Color.clear)
            .navigationBarItems(trailing: Button(action: {

                showSettings = false

            }) {

                Text("Done").foregroundColor(Color.pink).bold()

            })

        }

    }

}

// MARK: Assets and Strings
//
extension MenuViewContent {
    
    private enum Assets: String {
        case logo
    }
    
    private struct Strings {

        public static var appInfo: String {
            NSLocalizedString("com.okapi.menucontent.app-info", value: "App Info", comment: "App Info section header text")
        }

        public static var about: String {
            NSLocalizedString("com.okapi.menucontent.about", value: "About", comment: "About")
        }

        public static var feedback: String {
            NSLocalizedString("com.okapi.menucontent.feedback", value: "Feedback", comment: "Feedback")
        }

        public static var acknowledgements: String {
            NSLocalizedString("com.okapi.menucontent.acknowledgements", value: "Acknowledgements", comment: "Acknowledgements")
        }

    }

}

// MARK: Previews
//
struct MenuViewContent_Previews: PreviewProvider {

    static var previews: some View {

        MenuViewContent(showSettings: .constant(false))

    }

}
