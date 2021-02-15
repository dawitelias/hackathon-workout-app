//
//  PopupPanel.swift
//  Workouts
//
//  Created by Emily Cheroske on 7/5/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI
import ArcGIS

struct PopupPanel: View {

    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var viewModel: FullScreenMapViewModel

    var body: some View {

        let segmentSpecs = [
            (Strings.startDate, viewModel.segmentStartDate.hourAndMin),
            (Strings.endDate, viewModel.segmentEndDate.hourAndMin),
            (Strings.duration, viewModel.elapsedTimeString),
            (Strings.distance, viewModel.formattedDistanceString),
            (Strings.speed, viewModel.speedText),
            (Strings.elevationGain, viewModel.elevationGainText)
        ]

        return VStack(alignment: .leading) {
            
            VStack(alignment: .center, spacing: 3) {

                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(viewModel.settings.themeColor.color)
                    .frame(width: 30, height: 5)
                    .padding(.top, 10)

                HStack(alignment: .center) {

                    Text(Strings.selectedSegmentOverview)
                        .font(.title)
                        .foregroundColor(viewModel.settings.themeColor.color)
                        .padding(.horizontal)

                    Spacer()

                    Button(action: {

                        viewModel.selectedSegment.removeAll()

                    }, label: {

                        Image(systemName: Images.close.rawValue)
                            .resizable()
                            .frame(width: closeButtonDimension, height: closeButtonDimension, alignment: .center)
                            .padding(.all)

                    })

                }
            }

            Divider()
            
            VStack {

                ForEach(0...segmentSpecs.count - 1, id: \.self) { index in

                    PopupPanelListItem(title: segmentSpecs[index].0, value: segmentSpecs[index].1)

                    if index != segmentSpecs.count - 1 {

                        Divider()

                    }

                }

            }
            .padding(.horizontal)

        }
        .frame(width: UIScreen.main.bounds.width - 8, height: nil, alignment: .center)

    }

    private let closeButtonDimension: CGFloat = 25

}

extension PopupPanel {
    
    private enum Images: String {
        case close = "xmark.circle.fill"
    }

    private struct Strings {

        static var selectedSegmentOverview: String {
            NSLocalizedString("com.okapi.popupPanel.selected-segment-overview", value: "Segment Overview", comment: "Selected segment overview text")
        }

        static var startDate: String {
            NSLocalizedString("com.okapi.popupPanel.start-date", value: "Start Date", comment: "Start date string")
        }

        static var endDate: String {
            NSLocalizedString("com.okapi.popupPanel.end-date", value: "End Date", comment: "End date string")
        }

        static var duration: String {
            NSLocalizedString("com.okapi.popupPanel.duration", value: "Duration", comment: "Duration string")
        }

        static var distance: String {
            NSLocalizedString("com.okapi.popupPanel.distance", value: "Distance", comment: "Distance String")
        }

        static var speed: String {
            NSLocalizedString("com.okapi.popupPanel.speed", value: "Speed", comment: "Speed text")
        }

        static var elevationGain: String {
            NSLocalizedString("com.okapi.popupPanel.elevation-gain", value: "Elevation Gain", comment: "Elevation Gain")
        }

    }

}
