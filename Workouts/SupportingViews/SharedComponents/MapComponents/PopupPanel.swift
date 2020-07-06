//
//  PopupPanel.swift
//  Workouts
//
//  Created by Emily Cheroske on 7/5/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI
import ArcGIS

//enum SpeedAssesment {
//    case slowerThanAverage, average, fasterThanAverage
//}
//
//func getSpeedAssesment(maxSpeed: Double, segment: [AGSFeature]) -> SpeedAssesment {
//    let averageSpeed = segment.map { item in
//        return item.attributes["Speed"] as? Double ?? 0
//    }
//}

struct PopupPanel: View {
    @Binding var selectedSegment: [AGSFeature]
    var body: some View {
        let segmentStartDate = selectedSegment.first?.attributes["Timestamp"] as? Date ?? Date()
        let segmentEndDate = selectedSegment.last?.attributes["Timestamp"] as? Date ?? Date()
        
        return VStack(alignment: .center) {
            HStack(alignment: .center) {
                Text("Title")
                    .font(.title)
                    .fontWeight(.semibold)
                Spacer()
                Button(action: {
                    self.selectedSegment.removeAll()
                }, label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .center)
                        .padding()
                })
            }.padding([.leading,.trailing])
            HStack {
                Text("\(segmentStartDate.distance(to: segmentEndDate).getHoursAndMinutesString())")
                Text("\(segmentStartDate.hHmMsS) - \(segmentEndDate.hHmMsS)")
            }
        }
        .frame(width: UIScreen.main.bounds.width - 16, height: 150, alignment: .center)
        .background(Blur()
            .cornerRadius(3)
            .shadow(color: Color(UIColor.quaternaryLabel), radius: 1, x: 0, y: 0)
        )
    }
}

struct PopupPanel_Previews: PreviewProvider {
    static var previews: some View {
        PopupPanel(selectedSegment: .constant([AGSFeature]()))
    }
}
