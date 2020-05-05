//
//  HealthInfoScreen.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/29/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI
import HealthKit

struct HealthInfoScreen: View {
//    @State var age: Int
//    @State var gender: HKBiologicalSex
//    @State var bloodType: HKBloodType

    var body: some View {
        return List {
            Text("Age: 23")
            Text("Gender: F")
            Text("Blood Type: no idea")
        }
        .navigationBarTitle(Text("Health Info"), displayMode: .large)
    }
}

struct HealthInfoScreen_Previews: PreviewProvider {
    static var previews: some View {
        HealthInfoScreen()
    }
}
