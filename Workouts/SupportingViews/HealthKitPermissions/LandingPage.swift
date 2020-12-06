//
//  LandingPage.swift
//  Workouts
//
//  Created by Emily Cheroske on 5/31/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct LandingPage: View {

    @State var logoOpacity: Double = 0

    @State var landingPageOpacity: Double = 1

    var body: some View {

        return VStack(alignment: .center) {

            VStack(alignment: .center) {

                Spacer()

                Image(Images.logo.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .opacity(logoOpacity)
                    .foregroundColor(Color.white)
                    .padding()
                    .onAppear {
                        withAnimation(Animation.easeIn(duration: animationDuration)) {
                            logoOpacity = 1
                        }
                    }

            }
            .frame(width: screenWidth, height: halfScreenHeight)

            VStack(alignment: .center) {
                
                Text(Strings.landingPageTitle)
                    .foregroundColor(.white)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()

                Text(Strings.landingPageDescription)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()

                Button(action: {

                    HealthKitAssistant.checkAccess() { success, error in

                        if error != nil {
                            return
                        }

                        // We need to save this to UserDefaults
                        //
                        UserDefaults.standard.set(true, forKey: "permissionsGranted")
                        
                        // Jump back on the main thread and set the root vc to be the main home page
                        //
                        DispatchQueue.main.async {
                            // Get access tot he scene
                            //
                            let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene

                            if let windowScenedelegate = scene?.delegate as? SceneDelegate {
                               let window = UIWindow(windowScene: scene!)
                                
                               window.rootViewController = UIHostingController(rootView: HomeView().environmentObject(WorkoutData()))
                               windowScenedelegate.window = window
                               window.makeKeyAndVisible()
                            }
                        }
                    }
                }) {
                    Text(Strings.continueText)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .border(Color.white, width: 1)
                }
                
                Spacer()
            }
            .frame(width: screenWidth, height: halfScreenHeight)
            .opacity(logoOpacity)
            .onAppear {
                withAnimation(Animation.easeIn(duration: animationDuration)) {
                    logoOpacity = 1
                }
            }
            .padding()
            .background(Color(UIColor.black.withAlphaComponent(0.7)))
        }
        .opacity(landingPageOpacity)
        .background(Image(Images.landingPageImage.rawValue))
        .onDisappear {
            withAnimation(Animation.easeOut(duration: animationDuration)) {
                landingPageOpacity = 0
            }
        }
    }

    private let animationDuration = 0.7
    private let halfScreenHeight = UIScreen.main.bounds.height / 2
    private let screenWidth = UIScreen.main.bounds.width
}

// MARK: Landing page assets and text
//
extension LandingPage {
    
    private enum Images: String {
        case landingPageImage = "LandingPageImage"
        case logo
    }

    private struct Strings {

        public static var landingPageTitle: String {
            NSLocalizedString("com.okapi.landingPage.title", value: "Bringing the power of GIS to your workouts.", comment: "Title for landing page of okapi app.")
        }

        public static var continueText: String {
            NSLocalizedString("com.okapi.landingPage.continue-button", value: "Continue", comment: "title for the landing page")
        }

        public static var landingPageDescription: String {
            NSLocalizedString("com.okapi.landingPage.landing-page-description", value: "Okapi relies on health kit to read and store you workout data. Please grant us permissions to access your data so that we can give you the best in-app experience possible.", comment: "Explain why okapi needs health kit permissions")
        }
    }

}

// MARK: Landing Page Preview
//
struct LandingPage_Previews: PreviewProvider {
    static var previews: some View {
        LandingPage()
    }
}
