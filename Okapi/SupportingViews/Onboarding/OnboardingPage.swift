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
    
    @State var textOpacity: Double = 0

    var body: some View {

        GeometryReader { g in

            VStack(alignment: .center) {

                Spacer()

                VStack(alignment: .leading) {

                    Text(title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .opacity(textOpacity)

                    Text(subtitle)
                        .font(.subheadline)
                        .opacity(textOpacity)

                }
                .frame(width: g.size.width - textPadding)
                .padding(.horizontal)

                // Capture an image of the heart rate chart to display here
                //
                Image(imageName)
                    .resizable()
                    .opacity(textOpacity)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: g.size.width - imagePadding, height: nil)
                    .cornerRadius(imageCornerRadius)

                Spacer()

            }

        }
        .onAppear {

            withAnimation {

                textOpacity = 1

            }

        }

    }

    private let textPadding: CGFloat = 20
    private let imagePadding: CGFloat = 30
    private let imageCornerRadius: CGFloat = 10
}

struct HeartRate_Previews: PreviewProvider {

    static var previews: some View {

        OnboardingPage(
            imageName: "LandingPageImage",
            title: "Onboarding page",
            subtitle: "onboarding page subtitle")

    }

}
