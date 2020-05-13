//
//  ElevationChart.swift
//  Workouts
//
//  Created by Emily Cheroske on 5/10/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI
import CoreLocation

struct ElevationChart: View {
    var elevationData: [CLLocation]
    var body: some View {
        let data = elevationData.map { return $0.altitude }

        return ZStack {
            Graph(rawData: data, capsuleColor: .orange, backgroundColor: .black)
        }
    }
}

struct ElevationChart_Previews: PreviewProvider {
    static var previews: some View {
        ElevationChart(elevationData: [CLLocation(latitude: 0, longitude: 0)]) // TODO: come up with better preview data
    }
}
