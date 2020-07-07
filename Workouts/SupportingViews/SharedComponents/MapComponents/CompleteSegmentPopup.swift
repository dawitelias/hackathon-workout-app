//
//  CompleteSegmentPopup.swift
//  Workouts
//
//  Created by Emily Cheroske on 7/6/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct CompleteSegmentPopup: View {
    var body: some View {

        return VStack(alignment: .center) {
            Text("Tap another point on the route to complete the segment.")
                .padding(30)
        }
        .frame(width: UIScreen.main.bounds.width - 16, height: nil, alignment: .center)
        .background(Color(UIColor.secondarySystemBackground)
            .cornerRadius(10)
            .shadow(color: Color(UIColor.quaternaryLabel), radius: 1, x: 0, y: 0)
        )
        .padding()
    }
}

struct CompleteSegmentPopup_Previews: PreviewProvider {
    static var previews: some View {
        CompleteSegmentPopup()
    }
}
