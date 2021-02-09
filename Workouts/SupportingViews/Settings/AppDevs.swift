//
//  AppDevs.swift
//  Workouts
//
//  Created by Emily Cheroske on 2/8/21.
//  Copyright © 2021 Dawit Elias. All rights reserved.
//

import SwiftUI

struct AppDevs: View {

    var body: some View {

        Section(header: Text(Strings.designedAndDevelopedBy).font(.body)) {

            DesignerDeveloperRow(imageName: "dawit", name: "Dawit Elias", description: "The good designer", twitterScreenName: "da_weet", linkedInProfileID: "dawitelias")

            DesignerDeveloperRow(imageName: "emily", name: "Emily Cheroske", description: "The crazy designer/developer/SwiftUI freak", twitterScreenName: "EmilyCheroske", linkedInProfileID: "emily-cheroske-37476b165")

        }

    }

}

extension AppDevs {

    struct Strings {

        public static var designedAndDevelopedBy: String {
            NSLocalizedString("com.okapi.settings.designedAndDevelopedBy", value: "Designed and Developed By:", comment: "Section header for designed and developed by.")
        }

    }

}
