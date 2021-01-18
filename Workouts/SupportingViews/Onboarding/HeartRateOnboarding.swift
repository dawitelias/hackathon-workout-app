//
//  HeartRate.swift
//  Workouts
//
//  Created by Emily Cheroske on 1/16/21.
//  Copyright © 2021 Dawit Elias. All rights reserved.
//

import SwiftUI

struct OnboardingPage: View {

    let imageName: String
    let title: String
    let subtitle: String

    var body: some View {

        GeometryReader { g in

            VStack(alignment: .center) {

                Spacer()

                VStack(alignment: .leading) {

                    Text(title)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(subtitle)
                        .font(.subheadline)

                }
                .frame(width: g.size.width - textPadding)
                .padding(.horizontal)

                // Capture an image of the heart rate chart to display here
                //
                Image(imageName)
                    .resizable()
                    .frame(width: g.size.width - imagePadding, height: g.size.width - imagePadding)

                Spacer()

            }

        }

    }

    private let textPadding: CGFloat = 20
    private let imagePadding: CGFloat = 30

}

struct HeartRate_Previews: PreviewProvider {

    static var previews: some View {

        OnboardingPage(
            imageName: "LandingPageImage",
            title: "Onboarding page",
            subtitle: "onboarding page subtitle")

    }

}
