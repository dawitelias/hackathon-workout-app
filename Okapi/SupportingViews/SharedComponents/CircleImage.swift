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

    var body: some View {
        image
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .frame(width: imageDimension, height: imageDimension, alignment: .center)
            .padding(padding)
    }
    
    private let imageDimension: CGFloat = 20
    private let padding: CGFloat = 10
}

// MARK: Previews
//
struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(image: Image("Biking"))
    }
}
