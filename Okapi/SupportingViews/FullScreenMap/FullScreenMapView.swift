//
//  FullScreenMapView.swift
//  Workouts
//
//  Created by Emily Cheroske on 5/10/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI
import HealthKit
import CoreLocation
import MapKit
import ArcGIS

var generatedMapImage: UIImage = UIImage()

struct FullScreenMapView: View {
    
    @ObservedObject var viewModel: FullScreenMapViewModel

    @State var showShareSheet: Bool = false
    @State var mapView: AGSMapView = AGSMapView(frame: .zero)

    @State var slidingPanelPosition = SlidingPanelPosition.hidden

    var body: some View {

        return ZStack(alignment: .bottom) {

            EsriMapView(mapView: $mapView, isUserInteractionEnabled: true).environmentObject(viewModel)

            SlidingPanel(selectedSegment: $viewModel.selectedSegment) {
                
                Group {

                    if viewModel.selectedSegment.count == 1 {

                        VStack {

                            Text("Tap another point along the route to complete the segment.")
                                .padding()

                            Spacer()

                        }

                    } else if viewModel.selectedSegment.count > 1 {
                         
                        VStack {

                            PopupPanel().environmentObject(viewModel)

                            Spacer()

                        }

                    }
                }
                
            }
        }
        .edgesIgnoringSafeArea(.vertical)
        .navigationBarItems(trailing:

            Button(action: {

                if showShareSheet == false {

                    mapView.exportImage { image, error in

                        guard error == nil, let generatedImage = image else {
                            return
                        }

                        generatedMapImage = generatedImage
                        showShareSheet.toggle()

                    }

                } else {

                    showShareSheet.toggle()

                }

            }) {

                Image(systemName: Images.shareIcon.rawValue).imageScale(.large)

            }.sheet(isPresented: $showShareSheet) {

                ShareSheet(activityItems: [generatedMapImage, viewModel.getInfoText()])

            }
        )
    }
}

// MARK: Strings and assets
//
extension FullScreenMapView {

    private enum Images: String {
        case shareIcon = "square.and.arrow.up"
    }

    private struct Strings {

        static var selectPointPrompt: String {
            NSLocalizedString("com.okapi.fullScreenMap.selectPoint", value: "Select another point to complete the segment", comment: "Prompt the user to select another point on the map.")
        }

    }

}
