//
//  CircleImage.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/16/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
    var image: Image
    var color: Color = Color(UIColor(named: "CustomBlue")!)

    var body: some View {
        image
            .clipShape(Circle())
            .overlay(Circle().stroke(color, lineWidth: 1))
            .shadow(radius: 3)
            .frame(width: 20, height: 20, alignment: .center)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(image: Image("turtlerock"))
    }
}
