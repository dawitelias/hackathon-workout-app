//
//  FeaturedWorkout.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/16/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI
import HealthKit
import CoreLocation

struct FeaturedWorkout: View {
    var workout: HKWorkout
    @State var workoutHasRouteData = false
    @State var route: [CLLocation]? = nil
    @State var isLoading = true

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        let workoutHrAndMin = workout.duration.getHoursAndMinutesString()
        
        if route == nil {
            workout.getWorkoutLocationData() { results, error in
                self.isLoading = false
                if let err = error {
                    print(err.localizedDescription)
                    return
                }
                if let locations = results {
                    self.route = locations
                    if locations.count > 0 {
                        self.workoutHasRouteData = true
                    }
                }
            }
        }
        
        return VStack(alignment: .leading) {
            if isLoading {
                Text("Loading...")
                    .frame(height: 250)
            } else {
                if workoutHasRouteData {
                    HStack {
                        Icon(image: Image(workout.workoutActivityType.workoutTypeMetadata.systemIconName), mainColor: workout.workoutActivityType.workoutTypeMetadata.mainColor, highlightColor: workout.workoutActivityType.workoutTypeMetadata.highlightColor, size: 35)
                        VStack(alignment: .leading) {
                            Text(workout.workoutActivityType.workoutTypeMetadata.activityTypeDescription)
                                .font(.headline)
                                .fontWeight(.semibold)
                            Text("\(workout.endDate.date)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top)
                    if workout.getImageFromDocumentsDirectory(colorScheme: colorScheme) != nil {
                        Image(uiImage: workout.getImageFromDocumentsDirectory(colorScheme: colorScheme)!)
                            .resizable()
                            .frame(height: 200)
                            .padding(.horizontal, -15)
                            .padding(.bottom, -6)
                    } else {
                        EsriMapCard(workout: workout, route: self.route)
                            .frame(height: 200)
                            .padding(.horizontal, -15)
                            .padding(.bottom, -6)
                    }
                } else {
                    HStack {
                        ZStack(alignment: .topLeading) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(workout.workoutActivityType.workoutTypeMetadata.activityTypeDescription)
                                    .font(.largeTitle)
                                    .fontWeight(.heavy)
                                    .foregroundColor(workout.workoutActivityType.workoutTypeMetadata.highlightColor)
                                    .fixedSize()

                                Text("\(workoutHrAndMin)")
                                    .font(.largeTitle)
                                    .fontWeight(.heavy)
                                    .foregroundColor(Color(UIColor.label))

                                if workout.totalEnergyBurned != nil {
                                    Text("\(Int(workout.totalEnergyBurned!.doubleValue(for: .kilocalorie()))) cal")
                                        .font(.largeTitle)
                                        .fontWeight(.heavy)
                                        .foregroundColor(Color(UIColor.label))

                                }


                            }
                            .frame(width: 300, height: nil, alignment: .leading)
                            .padding(.leading, 20)
                            .padding(.top, 20)

                            VStack(alignment: .trailing, spacing: nil) {
                                Image(workout.workoutActivityType.workoutTypeMetadata.systemIconName)
                                    .foregroundColor(workout.workoutActivityType.workoutTypeMetadata.highlightColor)
                                    .opacity(0.2)
                            }.offset(x: 100, y: 0)
                        }
                    }
                    .cornerRadius(5)
                    .frame(height: 200)
                }
            }
        }
    }

}

struct FeaturedWorkout_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedWorkout(workout: HKWorkout(activityType: .running, start: Date(), end: Date()))
    }
}
