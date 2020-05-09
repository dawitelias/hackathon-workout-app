//
//  WorkoutDetail.swift
//  HealthKitSwiftUI
//
//  Created by Emily Cheroske on 4/15/20.
//  Copyright © 2020 Emily Cheroske. All rights reserved.
//

import SwiftUI
import HealthKit
import CoreLocation
import MapKit

var generatedMapImage: UIImage = UIImage()

struct WorkoutDetail: View {
    let workout: HKWorkout

    @State var route: [CLLocation]? = nil
    @State var showShareSheet: Bool = false

    var body: some View {
        let workoutDistance = workout.totalDistance?.doubleValue(for: .mile()) ?? 0
    
        let distanceString = "\(String.init(format: "%.0f", workoutDistance))mi"
        let workoutTimer = workout.duration.getTimerStyleActivityDurationString()
        let workoutHrAndMin = workout.duration.getHoursAndMinutesString()
        
        if route == nil {
            workout.getWorkoutLocationData { route, error in
                if let err = error {
                    print("error fetching route data")
                    return
                }
                self.route = route
            }
        }
        
        var altitudeData: [Double]?
        if let path = route, path.count > 0 {
            altitudeData = path.map { item in
                print(item.altitude)
                return item.altitude
            }
        }

        return VStack(spacing: 0) {
            MapView(workout: workout)

            VStack(alignment: .leading) {
                // header
                HStack {
                    Icon(image: Image(workout.workoutActivityType.workoutTypeMetadata.systemIconName), mainColor: workout.workoutActivityType.workoutTypeMetadata.mainColor, highlightColor: workout.workoutActivityType.workoutTypeMetadata.highlightColor, size: 35)

                    VStack(alignment: .leading) {
                        Text(workout.workoutActivityType.workoutTypeMetadata.activityTypeDescription)
                            .font(.title)
                            .fontWeight(.semibold)
                        Text("\(workout.startDate.weekday), " + "\(workoutHrAndMin)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                Divider()
                
                if altitudeData != nil {
                    Graph(rawData: altitudeData!).frame(width: nil, height: 100, alignment: .center).background(Color.pink)
                } else {
                    Text("AltitudeData was nil")
                }
                
                // metrics.. all static right now..
                // should add some extension styles to encourage reusability
                HStack {
                    VStack(alignment: .leading) {
                        Text("Total Time")
                        Text(workoutTimer)
                            .font(.system(.title, design: .rounded))
                            .foregroundColor(.yellow)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Distance")
                        Text(distanceString)
                            .font(.system(.title, design: .rounded))
                            .foregroundColor(.blue)
                    }
                    Spacer()
                }
                .padding(.vertical)
                HStack {
                    VStack(alignment: .leading) {
                        Text("Active Calories")
                        Text("\(workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0, specifier: "%.0f")cal")
                            .font(.system(.title, design: .rounded))
                            .foregroundColor(.pink)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Total Calories")
                        Text("\(workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0, specifier: "%.0f")cal")
                            .font(.system(.title, design: .rounded))
                            .foregroundColor(.pink)
                    }
                    Spacer()
                }
                .padding(.vertical)
                HStack {
                    VStack(alignment: .leading) {
                        Text("Avg. Heart Rate")
                        Text("155BPM")
                            .font(.system(.title, design: .rounded))
                            .foregroundColor(.orange)
                    }
                    
                }
                .padding(.vertical)
                HStack {
                    VStack(alignment: .leading) {
                        Text("Avg. Pace")
                        Text("7'23\"MI")
                            .font(.system(.title, design: .rounded))
                            .foregroundColor(Color("exerciseGreen"))
                    }
                    
                }
                .padding(.vertical)
            }
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color.init(UIColor.secondarySystemBackground))
            .clipped()
            .shadow(radius: 3, y: 0)
        }
        .edgesIgnoringSafeArea(.vertical)
        .navigationBarItems(trailing:
            Button(action: {
                if self.showShareSheet == false {
                    self.workout.getWorkoutLocationData { route, error in
                        guard let workoutRoute = route else {
                            return
                        }
                        MapImageGenerator.generateMapImageWithRoute(route: workoutRoute) {
                            image, error in
                            guard let generatedImage = image else {
                                return
                            }
                            generatedMapImage = generatedImage
                            self.showShareSheet.toggle()
                        }
                    }
                } else {
                    self.showShareSheet.toggle()
                }
            }) {
                Image(systemName: "square.and.arrow.up").imageScale(.large)
            }.sheet(isPresented: $showShareSheet) {
                ShareSheet(activityItems: [generatedMapImage, "\(distanceString) \u{1F525} \(workoutHrAndMin) \u{1F947} \n\n \(ChuckNorris.getRandomChuckNorrisQuote())"])
            }
        )
    }
}

struct WorkoutDetail_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutDetail(workout: HKWorkout(activityType: .running, start: Date(), end: Date()))
    }
}
