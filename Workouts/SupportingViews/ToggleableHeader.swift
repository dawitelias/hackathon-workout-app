//
//  ToggleableHeader.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/17/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct ToggleableHeader: View {
    var text: String
    @Binding var switchValue: Bool
    
    var body: some View {
        HStack {
            Toggle(isOn: $switchValue) {
                Text(text)
            }
        }
    }
}

struct ToggleableHeader_Previews: PreviewProvider {
    static var previews: some View {
        ToggleableHeader(text: "Test", switchValue: .constant(false))
    }
}
