//
//  Icon.swift
//  Workouts
//
//  Created by Emily Cheroske on 5/4/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct Icon: View {
    
    @Environment(\.colorScheme) var colorScheme

    var image: Image
    var mainColor: Color
    var highlightColor: Color
    var size: CGFloat

    var body: some View {
        VStack {
            image
                .resizable()
                .frame(width: size, height: size)
                .frame(width: size, height: size, alignment: .center)
                .padding(size * 0.3)
                .foregroundColor(Color(UIColor.black))
                .animation(.easeInOut, value: size)
            
        }
        .background(LinearGradient(
            gradient: .init(colors: [colorScheme == .dark ? .white : Color(UIColor.systemGray5), highlightColor]),
            startPoint: .init(x: 0.6, y: 0.0),
            endPoint: .init(x: 0.0, y: 0.9)
        ))
        .clipShape(Circle())
    }
}

struct Icon_Previews: PreviewProvider {
    static var previews: some View {
        Icon(image: Image("Cycling"), mainColor: .orange, highlightColor: .yellow, size: 100).environment(\.colorScheme, .dark)
    }
}