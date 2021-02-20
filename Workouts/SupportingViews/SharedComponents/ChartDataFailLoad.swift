//
//  ChartDataFailLoad.swift
//  Workouts
//
//  Created by Emily Cheroske on 2/5/21.
//  Copyright © 2021 Dawit Elias. All rights reserved.
//

import SwiftUI

struct ChartDataFailLoad: View {

    let text: String
    let height: CGFloat
    var showQuote: Bool = true
    
    @State var isAnimating = false
    @State var rotationAngle: Double = 0

    var body: some View {

        ZStack(alignment: .center) {

            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundColor(Color(UIColor.secondarySystemBackground))

            VStack {

                Spacer()

                Text(text)
                    .foregroundColor(Color(UIColor.label))

                if showQuote {
                    Text(DataDidntLoadQuotes.getRandomDissapointmentQuote())
                        .font(.caption)
                        .foregroundColor(Color(UIColor.secondaryLabel))
                        .italic()
                        .padding()
                }
                
                Spacer()

                Text("😢")
                    .font(.largeTitle)
                    .rotationEffect(.degrees(isAnimating ? animationAngle : rotationAngle))
                    .animation(Animation.linear(duration: animationDuration).repeatForever())
                    .onAppear {
                        self.isAnimating = true
                    }

                Spacer()

            }

        }
        .frame(width: nil, height: height)
        .cornerRadius(cornerRadius)
        .padding()

    }
    
    private let cornerRadius: CGFloat = 10
    private let animationDuration: Double = 2.0
    private let animationAngle: Double = 360

}

struct ChartDataFailLoad_Previews: PreviewProvider {

    static var previews: some View {

        ChartDataFailLoad(text: "Heart rate data failed to load", height: 350)

    }

}
