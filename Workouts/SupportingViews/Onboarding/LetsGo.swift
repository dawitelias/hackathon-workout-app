//
//  LetsGo.swift
//  Workouts
//
//  Created by Emily Cheroske on 1/17/21.
//  Copyright © 2021 Dawit Elias. All rights reserved.
//

import SwiftUI

struct LetsGo: View {

    let checkAccess: () -> Void

    var body: some View {
        
        VStack(alignment: .center) {

            Spacer()

            VStack(alignment: .leading) {

                Text(Strings.readyToGetStarted)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(Strings.requestHealthKitPermissions)
                    .font(.subheadline)

            }
            .padding(.horizontal, textPadding)

            Spacer()

            Button(action: {

                checkAccess()

            }, label: {

                ZStack {
                    
                    RoundedRectangle(cornerRadius: buttonCornerRadius)
                        .background(Color.blue)

                    Text(Strings.continueText)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)

                }
                .frame(width: buttonWidth, height: buttonHeight, alignment: .center)
                .cornerRadius(buttonCornerRadius)

            })
            .buttonStyle(DefaultButtonStyle())

            Spacer()
        }

    }

    private let textPadding: CGFloat = 20
    private let buttonCornerRadius: CGFloat = 10
    private let buttonWidth: CGFloat = 300
    private let buttonHeight: CGFloat = 50
}

extension LetsGo {
    
    private struct Strings {
        
        static var readyToGetStarted: String {
            NSLocalizedString("com.okapi.letsGo.ready-to-get-started", value: "Ready to get started?", comment: "Text for ready to get started?")
        }
        
        static var requestHealthKitPermissions: String {
            NSLocalizedString("com.okapi.letsGo.request-health-kit-permission", value: "Please grant us permissions to read your workout data saved in Health Kit so that we can give you the best in-app experience possible.", comment: "Description text explaining why we need health kit permissions.")
        }
        
        static var continueText: String {
            NSLocalizedString("com.okapi.letsgo.continue", value: "Continue", comment: "text prompting user to continue")
        }

    }

}

struct LetsGo_Previews: PreviewProvider {

    static var previews: some View {

        LetsGo(checkAccess: {

            print("Check Access")

        })

    }

}
