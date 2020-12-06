//
//  Licensing.swift
//  Workouts
//
//  Created by Emily Cheroske on 11/26/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct Licensing: View {
    var body: some View {
        VStack {
            Text(Strings.licensingPageTitle)
            Text("TODO: put this license text here: https://github.com/AppPear/ChartView/blob/master/LICENSE")
        }
    }
}

// MARK: Strings and Assets
//
extension Licensing {

    private struct Strings {

        public static var licensingPageTitle: String {
            NSLocalizedString("com.okapi.licensingPage.title", value: "Licensing Page", comment: "Title for the licensing page.")
        }

    }

}

// MARK: Previews
//
struct Licensing_Previews: PreviewProvider {
    static var previews: some View {
        Licensing()
    }
}
