//
//  Badges.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/29/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct Badges: View {
    var body: some View {
        Text("I've always wanted to do badges... I will implement. I think there should be two different types, lifetime (ie running a marathon) and weekly/goal type repeating badges")
        .navigationBarTitle(Text("Badges"), displayMode: .large)
    }
}

struct Badges_Previews: PreviewProvider {
    static var previews: some View {
        Badges()
    }
}
