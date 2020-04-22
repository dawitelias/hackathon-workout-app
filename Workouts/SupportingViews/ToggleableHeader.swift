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
    var currentValueText: String?
    @Binding var switchValue: Bool
    
    var body: some View {
        HStack {
            Toggle(isOn: $switchValue) {
                VStack(alignment: .leading, spacing: nil) {
                    Text(text)
                       .padding(.top, 20)
                       .padding(.bottom, 5)
                       .font(.system(size: 18, weight: .regular))

                    if currentValueText != nil {
                        Text(currentValueText!)
                            .padding(.bottom, 5)
                            .font(.system(size: 15, weight: .thin))
                    }
                }
               
            }
        }
    }
}

struct ToggleableHeader_Previews: PreviewProvider {
    static var previews: some View {
        ToggleableHeader(text: "Test", currentValueText: nil, switchValue: .constant(false))
    }
}
