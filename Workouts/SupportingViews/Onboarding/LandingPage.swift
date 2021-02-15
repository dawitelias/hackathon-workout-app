//
//  LandingPage.swift
//  Workouts
//
//  Created by Emily Cheroske on 1/16/21.
//  Copyright © 2021 Dawit Elias. All rights reserved.
//

import SwiftUI

struct LandingPage: View {

    private enum UserDefaultsKeys: String {
        case permissionsGranted
    }

    private func checkAccess() {

        HealthKitAssistant.checkAccess() { success, error in

            if error != nil {
                return
            }

            // We need to save this to UserDefaults
            //
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.permissionsGranted.rawValue)
            
            // Jump back on the main thread and set the root vc to be the main home page
            //
            DispatchQueue.main.async {

                // Get access to the scene
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

    }

    var body: some View {

        TabView {

            BrandPage()

            OnboardingPage(imageName: Images.workoutOverview.rawValue, title: Strings.workoutsTitle, subtitle: Strings.workoutsSubtitle)

            OnboardingPage(imageName: Images.highlightedRoute.rawValue, title: Strings.routeAndDistanceTitle, subtitle: Strings.routeAndDistanceSubtitle)

            OnboardingPage(imageName: Images.heartRateChart.rawValue, title: Strings.heartRateTitle, subtitle: Strings.heartRateSubtitle)
            
            LetsGo(checkAccess: {
                checkAccess()
            })

        }
        .padding(.bottom)
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .ignoresSafeArea()

    }

}

extension LandingPage {
    
    private enum Images: String {

        case heartRateChart = "HeartRateChart"
        case highlightedRoute = "WorkoutGISView"
        case workoutOverview = "WorkoutOverview"

    }
    
    private struct Strings {

        static var heartRateTitle: String {
            NSLocalizedString("com.okapi.landingpage.heart-rate-title", value: "Heart Rate", comment: "Title of heart rate onboarding page")
        }

        static var heartRateSubtitle: String {
            NSLocalizedString("com.okapi.landingpage.heart-rate-subtitle", value: "Get insight into your heart rate data recorded during your workout.", comment: "Subtitle of heart rate landing page.")
        }

        static var workoutsTitle: String {
            NSLocalizedString("com.okapi.landingpage.workouts-title", value: "Health Kit Workout Data", comment: "Title of healthkit workouts onboarding page")
        }

        static var workoutsSubtitle: String {
            NSLocalizedString("com.okapi.landingpage.workouts-subtitle", value: "We show you your health kit workout data in a whole new way.", comment: "Subtitle of health kit workouts onboarding page")
        }

        static var routeAndDistanceTitle: String {
            NSLocalizedString("com.okapi.landingpage.route-and-distance-title", value: "Workout Route and Distance", comment: "Workout route and distance data title")
        }

        static var routeAndDistanceSubtitle: String {
            NSLocalizedString("com.okapi.landingpage.route-and-distance-subtitle", value: "Use GIS to dig into your workout route data.", comment: "Workout route and distance subtitle")
        }

    }

}
// Active Energy
// Cycling Distance
// Heart Rate
// Walking + Running Distance
// Workout Routes
// Workouts

struct LandingPage_Previews: PreviewProvider {

    static var previews: some View {

        LandingPage()

    }

}
