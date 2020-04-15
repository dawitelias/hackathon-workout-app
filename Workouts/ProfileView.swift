//
//  ProfileView.swift
//  Workouts
//
//  Created by Dawit Elias on 4/15/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    
    @Binding var showProfileView: Bool

    var body: some View {
        NavigationView {
            Form {
                Button(action: {
                    // your action here
                    self.authorizeHealthKit()
                }) {
                    HStack {
                        Spacer()
                        Text("Authorize HealthKit").bold()
                        Spacer()
                    }
                }
            }
            .navigationBarTitle(Text("Profile"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.showProfileView = false
                }) {
                    Text("Done").bold()
                })
        }
    }
    
    private func authorizeHealthKit() {
      HealthKitSetupAssistant.authorizeHealthKit { (authorized, error) in
            
        guard authorized else {
          let baseMessage = "HealthKit Authorization Failed"
              
          if let error = error {
            print("\(baseMessage). Reason: \(error.localizedDescription)")
          } else {
            print(baseMessage)
          }
              
          return
        }
            
        print("HealthKit Successfully Authorized.")
      }
    }
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(showProfileView: .constant(false))
    }
}
