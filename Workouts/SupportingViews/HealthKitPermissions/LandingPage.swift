//
//  LandingPage.swift
//  Workouts
//
//  Created by Emily Cheroske on 5/31/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct LandingPage: View {
    var body: some View {
        return VStack(alignment: .center, spacing: 30) {
            VStack(alignment: .center, spacing: 30) {
                Text("Welcome to the Workouts App!")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)

                Text("Please grant Workouts permission to read your workout data from HealthKit. Without it, the app is very boring. ❤️")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)

                Button(action: {
                    HealthKitAssistant.checkAccess() { success, error in
                        if let error = error {
                            print(error.localizedDescription)
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
                    Text("Grant permissions")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .border(Color.white, width: 1)
                }
            }
            .padding(30)
            .background(Color(red: 0, green: 0, blue: 0, opacity: 0.7))
            
        }
        .background(Image("LandingPageImage"))
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }
}

struct LandingPage_Previews: PreviewProvider {
    static var previews: some View {
        LandingPage()
    }
}
