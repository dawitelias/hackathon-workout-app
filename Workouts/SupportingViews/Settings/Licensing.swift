//
//  Licensing.swift
//  Workouts
//
//  Created by Emily Cheroske on 11/26/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct Licensing: View {
    var body: some View {

        ScrollView {

            VStack(alignment: .leading) {

                Text("ArcGIS")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Okapi's GIS capabilities are made possible using the ArcGIS iOS SDK! Check it out!")

                Link("Check it out here.",
                      destination: URL(string: "https://developers.arcgis.com/ios/")!)
                    .foregroundColor(.blue)

                ZStack {

                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)

                    Image("esriLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 100)

                }

            }.padding()

            VStack(alignment: .leading) {

                Text("SwiftUICharts")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Without SwiftUICharts, Okapi's speed, elevation and heart rate visualizations wouldn't be as rad 😎")

                Link("Check it out here.",
                     destination: URL(string: "https://github.com/AppPear/ChartView")!)
                    .foregroundColor(.blue)

                ZStack {

                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color(UIColor.secondarySystemBackground))

                    Text("MIT License\n\nCopyright (c) 2019 Andras Samu\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: \n\n The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\n THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.")
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()

                }.padding()
                
            }.padding()

        }
        .navigationBarTitle(Strings.acknowledgmentPageTitle, displayMode: .inline)
    }
}

// MARK: Strings and Assets
//
extension Licensing {

    private struct Strings {

        public static var acknowledgmentPageTitle: String {
            NSLocalizedString("com.okapi.licensingPage.title", value: "Acknowledgments", comment: "Title for the acknowledgments page.")
        }

    }

}

// MARK: Previews
//
struct Licensing_Previews: PreviewProvider {
    static var previews: some View {
        Licensing()
    }
}
