//
//  Handle.swift
//  Workouts
//
//  Created by Emily Cheroske on 12/3/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

// NOTE: Implementation taken from here: https://www.mozzafiller.com/posts/swiftui-slide-over-card-like-maps-stocks

import SwiftUI

struct Handle : View {
    private let handleThickness = CGFloat(5.0)
    var body: some View {
        RoundedRectangle(cornerRadius: handleThickness / 2.0)
            .frame(width: 40, height: 30)
            .foregroundColor(Color(UIColor.systemRed))
            .padding(5)
    }
}
