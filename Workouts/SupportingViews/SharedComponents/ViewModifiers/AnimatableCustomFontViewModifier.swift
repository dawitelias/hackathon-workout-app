//
//  AnimatableCustomFontViewModifier.swift
//  Workouts
//
//  Created by Emily Cheroske on 12/2/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct AnimatableCustomFontModifier: AnimatableModifier {
    var size: CGFloat

    var animatableData: CGFloat {
        get { size }
        set { size = newValue }
    }

    func body(content: Content) -> some View {
        content
            .font(.system(size: size))
    }
}

extension View {
    func animatableFont(size: CGFloat) -> some View {
        self.modifier(AnimatableCustomFontModifier(size: size))
    }
}

extension View {
    public func gradientForeground(colors: [Color]) -> some View {
        self.overlay(LinearGradient(gradient: .init(colors: colors),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing))
            .mask(self)
    }
}
