//
//  View+Extensions.swift
//  Okapi
//
//  Created by Emily Cheroske on 2/14/21.
//  Copyright © 2021 Dawit Elias. All rights reserved.
//

import SwiftUI

extension View {
    @ViewBuilder
    func redacted(when condition: Bool) -> some View {
        if !condition {
            unredacted()
        } else {
            redacted(reason: .placeholder)
        }
    }
}
