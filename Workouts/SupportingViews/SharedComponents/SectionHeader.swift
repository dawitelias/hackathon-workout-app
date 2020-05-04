//
//  SectionHeader.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/29/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct SectionHeader: View {
    var text: String
    var body: some View {
        VStack {
            Text(text)
                .padding(.all)
                .font(.system(size: 21, weight: .medium))
                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
        }
    }
}

struct SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeader(text: "An awesome section header 🏅")
    }
}
