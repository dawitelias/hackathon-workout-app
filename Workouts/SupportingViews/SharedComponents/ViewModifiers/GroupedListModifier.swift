//
//  GroupedListModifier.swift
//  Workouts
//
//  Created by Emily Cheroske on 11/15/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct GroupedListModifier: ViewModifier {
    func body(content: Content) -> some View {
        Group {
            if #available(iOS 14, *) {
                content
                    .listStyle(InsetGroupedListStyle())
            } else {
                content
                    .listStyle(GroupedListStyle())
                    .environment(\.horizontalSizeClass, .regular)
            }
        }
    }
}
