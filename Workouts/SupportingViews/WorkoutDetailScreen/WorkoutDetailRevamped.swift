//
//  WorkoutDetailRevamped.swift
//  Workouts
//
//  Created by Emily Cheroske on 5/10/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI
import HealthKit
import CoreLocation
import MapKit

var generatedMapImageTwo: UIImage = UIImage()

struct WorkoutDetailRevamped: View {
    let workout: HKWorkout

    @State var route: [CLLocation]? = nil
    @State var workoutHRData: [Double]? = nil
    @State var selectedChart: Int = 2 // HR Chart selected by default

    var body: some View {
        let workoutDistance = workout.totalDistance?.doubleValue(for: .mile()) ?? 0
        let distanceString = "\(String.init(format: "%.0f", workoutDistance))mi"
        let workoutTimer = workout.duration.getTimerStyleActivityDurationString()
        let workoutHrAndMin = workout.duration.getHoursAndMinutesString()
        
        if route == nil {
            workout.getWorkoutLocationData { route, error in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                self.route = route
            }
        }
        if workoutHRData == nil {
            workout.getWorkoutHeartRateData() { results, error in
                if let error = error {
                    // TODO: display to user
                    print(error.localizedDescription)
                    return
                }
                self.workoutHRData = results
            }
        }
        
        var altitudeData: [Double]?
        var velocityData: [Double]?
        var coordinates: [CLLocationCoordinate2D]?
        if let path = route, path.count > 0 {
            altitudeData = path.map { item in
                return item.altitude
            }
            coordinates = path.map { return $0.coordinate }
            velocityData = path.map { item in
                return item.speed
            }
        }
        
        return ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Icon(image: Image(workout.workoutActivityType.workoutTypeMetadata.systemIconName), mainColor: workout.workoutActivityType.workoutTypeMetadata.mainColor, highlightColor: workout.workoutActivityType.workoutTypeMetadata.highlightColor, size: 50)
                        .padding()
                    VStack(alignment: .leading) {
                        HStack {
                            Text("\(workout.startDate.weekday), \(workout.startDate.date)")
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                        }
                        Text("\(workoutHrAndMin) 🔥")
                            .font(.system(.largeTitle, design: .rounded))
                    }
                }
                HStack {
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Total Time")
                        Text(workoutTimer)
                            .font(.largeTitle)
                            .fontWeight(.regular)
                            .foregroundColor(workout.workoutActivityType.workoutTypeMetadata.mainColor)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Calories")
                        Text("\(workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0, specifier: "%.0f")cal")
                            .font(.largeTitle)
                            .fontWeight(.regular)
                            .foregroundColor(workout.workoutActivityType.workoutTypeMetadata.mainColor)
                    }
                    Spacer()
                    if route != nil && route!.count != 0 {
                        VStack(alignment: .leading) {
                            Text("Distance")
                            Text(distanceString)
                                .font(.largeTitle)
                                .fontWeight(.regular)
                                .foregroundColor(workout.workoutActivityType.workoutTypeMetadata.mainColor)
                        }
                    }
                    Spacer()
                }

                // Render a map showing route data if the workout HAS route data...
                //
                if route != nil && route!.count != 0 {
                    VStack(alignment: .leading) {
                        NavigationLink(destination: FullScreenMapView(workout: workout)) {
                            MapView(workout: workout, isUserInteractionEnabled: false)
                            .frame(width: nil, height: 200, alignment: .center)
                            .cornerRadius(20)
                        }
                        
                    }
                    .padding(.leading, 5)
                    .padding(.trailing, 5)
                }
            
                // Show pace data, elevation data and HR data
                //
                VStack(alignment: .leading) {
                    Text("Data Visualization")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .padding()

                    if selectedChart == 0 && route != nil {
                        VStack {
                            ElevationChart(elevationData: route!)
                        }.frame(width: nil, height: 150)
                    }
                    if selectedChart == 1 && velocityData != nil {
                        VStack {
                            Graph(rawData: velocityData!)
                        }.frame(width: nil, height: 150)
                    }
                    if selectedChart == 2 && workoutHRData != nil {
                        VStack {
                            Graph(rawData: workoutHRData!)
                        }.frame(width: nil, height: 150)
                    }
                    Picker(selection: $selectedChart, label: Text("What is your favorite color?")) {
                        if altitudeData != nil {
                            Text("Elevation").tag(0)
                        }
                        if velocityData != nil {
                            Text("Speed").tag(1)
                        }
                        if self.workoutHRData != nil {
                            Text("Heart Rate").tag(2)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
            }
        }
        .navigationBarTitle(Text(workout.workoutActivityType.workoutTypeMetadata.activityTypeDescription), displayMode: .large)
    }
}

struct WorkoutDetailRevamped_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutDetailRevamped(workout: HKWorkout(activityType: .running, start: Date(), end: Date()))
    }
}
