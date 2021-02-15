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

                Text(Strings.arcGIS)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(Strings.arcGISUsage)

                Link(Strings.checkItOut,
                      destination: URL(string: arcGISLink)!)
                    .foregroundColor(.blue)

                ZStack {

                    RoundedRectangle(cornerRadius: cornerRadius)
                        .foregroundColor(.white)

                    Image(Images.esri.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: logoWidth, height: logoHeight)

                }

            }.padding()

            VStack(alignment: .leading) {

                Text(Strings.swiftUICharts)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(Strings.swiftuiChartsUsage)

                Link(Strings.checkItOut,
                     destination: URL(string: swiftUIChartsURL)!)
                    .foregroundColor(.blue)

                ZStack {

                    RoundedRectangle(cornerRadius: cornerRadius)
                        .foregroundColor(Color(UIColor.secondarySystemBackground))

                    Text("MIT License\n\nCopyright (c) 2019 Andras Samu\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: \n\n The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\n THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.")
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()

                }.padding()
                
            }.padding()

        }
        .navigationBarTitle(Strings.acknowledgmentPageTitle, displayMode: .inline)

    }
    
    private let logoHeight: CGFloat = 100
    private let logoWidth: CGFloat = 200
    private let cornerRadius: CGFloat = 10
    private let swiftUIChartsURL = "https://github.com/AppPear/ChartView"
    private let arcGISLink = "https://developers.arcgis.com/ios/"

}

// MARK: Strings and Assets
//
extension Licensing {
    
    private enum Images: String {
        case esri = "esriLogo"
    }

    private struct Strings {

        public static var checkItOut: String {
            NSLocalizedString("com.okapi.achnoledgements.checkItOut", value: "Check it out here.", comment: "Check it out")
        }

        public static var swiftUICharts: String {
            "SwiftUICharts"
        }
        
        public static var arcGIS: String {
            "ArcGIS"
        }

        public static var swiftuiChartsUsage: String {
            NSLocalizedString("com.okapi.acknowledgments.swiftuiChartsUsage", value: "Without SwiftUICharts, Okapi's speed, elevation and heart rate visualizations wouldn't be as rad 😎", comment: "Desicribing how Okapi uses charts")
        }

        public static var arcGISUsage: String {
            NSLocalizedString("com.okapi.achnoledgements.arcgisUsage", value: "Okapi's GIS capabilities are made possible using the ArcGIS iOS SDK! Check it out!", comment: "Arcgis usage in Okapi.")
        }

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
