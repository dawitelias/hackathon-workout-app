//
//  AboutScreen.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/29/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct AboutScreen: View {
    var body: some View {
        VStack {
            Text("A note about the app and stuff. ")
            Text("I think we should take a tip from Jeff and Justin and link out to our twitter pages here.")
            Text("If we throw together a website (need to for AppStore) - link to it here - any social media stuff")
        }
    }
}

struct AboutScreen_Previews: PreviewProvider {
    static var previews: some View {
        AboutScreen()
    }
}
