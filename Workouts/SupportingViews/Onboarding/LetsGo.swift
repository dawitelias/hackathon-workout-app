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

                Text(Strings.healthKitIntegration)
                    .font(.subheadline)
                
                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        Text("🥇")
                            .font(.body)
                        Text(Strings.workoutAndWorkoutRoutes)
                            .font(.body)
                    }
                    .padding()
                    
                    HStack {
                        Text("👟")
                            .font(.body)
                        Text(Strings.walkingAndRunningDistance)
                            .font(.body)
                    }
                    .padding()
                   
                    HStack {
                        Text("🚲")
                            .font(.body)
                        Text(Strings.cyclingDistance)
                            .font(.body)
                    }
                    .padding()
                    
                    HStack {
                        Text("♥️")
                            .font(.body)
                        Text(Strings.heartRateData)
                            .font(.body)
                    }
                    .padding()
                    
                    HStack {
                        Text("🔥")
                            .font(.body)
                        Text(Strings.calories)
                            .font(.body)
                    }
                    .padding()
                    
                }
                .cornerRadius(3)
                .background(Color(UIColor.secondarySystemBackground))

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
        
        static var healthKitIntegration: String {
            NSLocalizedString("com.okapi.letsGo.healthKitIntegration", value: "Okapi integrates deeply with HealthKit. We will request the following permissions to read your data so that we can give you a complete in-app experience:", comment: "Stating that Okapi integrates with HealthKit")
        }
        
        static var workoutAndWorkoutRoutes: String {
            NSLocalizedString("com.okapi.letsGo.workoutAndWorkoutRoutes", value: "Workout and workout routes", comment: "Workout and workout routes")
        }

        static var walkingAndRunningDistance: String {
            NSLocalizedString("com.okapi.letsGo.walkingAndRunningDistance", value: "Walking and running distance", comment: "Walking and running distance")
        }

        static var cyclingDistance: String {
            NSLocalizedString("com.okapi.letsGo.cyclingDistance", value: "Cycling distance", comment: "Cycling distance")
        }
        
        static var heartRateData: String {
            NSLocalizedString("com.okapi.letsGo.hr", value: "Heart rate", comment: "heart rate data")
        }
        
        static var calories: String {
            NSLocalizedString("com.okapi.letsGo.calories", value: "Active Energy (Calories burned)", comment: "calories")
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
