//
//  BrandPage.swift
//  Workouts
//
//  Created by Emily Cheroske on 1/17/21.
//  Copyright © 2021 Dawit Elias. All rights reserved.
//

import SwiftUI

struct BrandPage: View {

    @State var logoOpacity: Double = 0

    @State var landingPageOpacity: Double = 1

    var body: some View {

        return VStack(alignment: .center) {

            Image(Images.logo.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(logoOpacity)
                .padding([.horizontal, .top])
                .onAppear {
                    withAnimation(Animation.easeIn(duration: animationDuration)) {
                        logoOpacity = 1
                    }
                }.padding(.top, 100)

            Spacer()

        }
        .opacity(landingPageOpacity)

    }

    private let animationDuration = 0.7
    private let halfScreenHeight = UIScreen.main.bounds.height / 2
    private let screenWidth = UIScreen.main.bounds.width
}

extension BrandPage {

    private enum Images: String {
        case logo
    }

}

struct BrandPage_Previews: PreviewProvider {
    static var previews: some View {
        BrandPage()
    }
}
