//
//  CompleteSegmentPopup.swift
//  Workouts
//
//  Created by Emily Cheroske on 7/6/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct CompleteSegmentPopup: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        return VStack(alignment: .center) {
            Text("Tap another point on the route to complete the segment.")
                .padding(30)
        }
        .frame(width: UIScreen.main.bounds.width - 16, height: nil, alignment: .center)
        .background(Color(UIColor.secondarySystemBackground)
            .cornerRadius(10)
            .shadow(color: Color(colorScheme == .dark ? UIColor.black : UIColor.systemGray3), radius: 2, x: 1, y: 1)
        )
        .padding()
    }
}

struct CompleteSegmentPopup_Previews: PreviewProvider {
    static var previews: some View {
        CompleteSegmentPopup()
    }
}
