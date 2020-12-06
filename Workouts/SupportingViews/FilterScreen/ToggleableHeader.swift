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

                VStack(alignment: .leading) {

                    Text(text)
                       .font(.system(size: mainTextFontSize, weight: .regular))

                    if currentValueText != nil {

                        Text(currentValueText!)
                            .padding(.bottom, currentValueBottomPadding)
                            .font(.system(size: currentValueFontSize, weight: .thin))

                    }

                }

            }

        }

    }

    private let currentValueFontSize: CGFloat = 15
    private let currentValueBottomPadding: CGFloat = 5
    private let mainTextFontSize: CGFloat = 18
}

// MARK: Previews
//
struct ToggleableHeader_Previews: PreviewProvider {
    static var previews: some View {
        ToggleableHeader(text: "Test", currentValueText: nil, switchValue: .constant(false))
    }
}
