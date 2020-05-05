//
//  WeeklySummary.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/29/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct WeeklySummary: View {
    var body: some View {
        Text("Data showing number of days exercised per week... that kind of thing. Seems like there's a lot of opportunity to explore this idea more.")
            .navigationBarTitle(Text("Weekly Summary"), displayMode: .large)
    }
}

struct WeeklySummary_Previews: PreviewProvider {
    static var previews: some View {
        WeeklySummary()
    }
}
