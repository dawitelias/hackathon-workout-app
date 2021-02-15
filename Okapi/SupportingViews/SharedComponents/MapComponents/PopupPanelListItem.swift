//
//  PopupPanelListItem.swift
//  Workouts
//
//  Created by Emily Cheroske on 1/18/21.
//  Copyright © 2021 Dawit Elias. All rights reserved.
//

import SwiftUI

struct PopupPanelListItem: View {

    let title: String
    let value: String

    var body: some View {

        HStack {

            Text(title)
                .fontWeight(.bold)

            Spacer()
            
            Text(value)
                .fontWeight(.thin)

        }

    }

}

