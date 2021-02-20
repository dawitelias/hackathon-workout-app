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

class FeaturedWorkoutViewModel: ObservableObject {
    
    let workout: HKWorkout

    @Published var workoutHasRouteData: Bool = false

    @Published var workoutRouteLoading: Bool = true

    @Published var route: [CLLocation]? = nil
    
    init(workout: HKWorkout) {
        
        self.workout = workout

        workout.getWorkoutLocationData() { [weak self] results, error in

            guard let mySelf = self else {
                return
            }

            mySelf.workoutRouteLoading = false

            if let err = error {
                print(err.localizedDescription)
                return
            }
            
            if let locations = results {
                mySelf.route = locations
                if locations.count > 0 {
                    mySelf.workoutHasRouteData = true
                }

            }

        }

    }

}

struct FeaturedWorkout: View {

    @Environment(\.colorScheme) var colorScheme

    @ObservedObject var viewModel: FeaturedWorkoutViewModel

    init(workout: HKWorkout) {

        viewModel = FeaturedWorkoutViewModel(workout: workout)

    }
    
    var workoutHrAndMin: String {

        viewModel.workout.duration.getHoursAndMinutesString()

    }

    var distanceString: String {

        guard let dist = viewModel.workout.totalDistance else {
            return ""
        }

        return "\(String.init(format: "%.2f", dist))mi"
    }

    var body: some View {

        VStack(alignment: .leading) {

            if viewModel.workoutHasRouteData {

                HStack {

                    Icon(image: Image(viewModel.workout.workoutActivityType.workoutTypeMetadata.systemIconName), mainColor: viewModel.workout.workoutActivityType.workoutTypeMetadata.mainColor, highlightColor: viewModel.workout.workoutActivityType.workoutTypeMetadata.highlightColor, size: 35)

                    VStack(alignment: .leading) {

                        Text(viewModel.workout.workoutActivityType.workoutTypeMetadata.activityTypeDescription)
                            .font(.headline)
                            .fontWeight(.semibold)

                        Text("\(viewModel.workout.endDate.date)")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                    }

                }
                .padding(.top, 5)

                if viewModel.workout.getImageFromDocumentsDirectory(colorScheme: colorScheme) != nil {

                    Image(uiImage: viewModel.workout.getImageFromDocumentsDirectory(colorScheme: colorScheme)!)
                        .resizable()
                        .frame(height: 200)
                        .padding(.horizontal, -40)
                        .padding(.bottom, -20)

                }
                // else {
//
//                    EsriMapCard(workout: viewModel.workout, route: viewModel.route)
//                        .frame(height: 200)
//                        .padding(.horizontal, -40)
//                        .padding(.bottom, -20)
//
//                }

            } else {
                HStack {
                    ZStack(alignment: .topLeading) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(viewModel.workout.workoutActivityType.workoutTypeMetadata.activityTypeDescription)
                                .font(.title)
                                .fontWeight(.heavy)
                                .foregroundColor(viewModel.workout.workoutActivityType.workoutTypeMetadata.highlightColor)
                                .fixedSize(horizontal: false, vertical: true)
                                .minimumScaleFactor(0.01)

                            Text("\(workoutHrAndMin)")
                                .font(.title)
                                .fontWeight(.heavy)
                                .foregroundColor(Color(UIColor.label))
                            
                            if viewModel.workout.totalDistance != nil {
                                Text(distanceString)
                                    .font(.title)
                                    .fontWeight(.heavy)
                                    .foregroundColor(Color(UIColor.label))
                            } else if viewModel.workout.totalEnergyBurned != nil {
                                Text("\(Int(viewModel.workout.totalEnergyBurned!.doubleValue(for: .kilocalorie()))) cal")
                                    .font(.title)
                                    .fontWeight(.heavy)
                                    .foregroundColor(Color(UIColor.label))
                                
                            }


                        }
                        .frame(width: 300, height: nil, alignment: .leading)
                        .padding(.leading, 20)
                        .padding(.top, 20)

                        VStack(alignment: .trailing, spacing: nil) {

                            Image(viewModel.workout.workoutActivityType.workoutTypeMetadata.systemIconName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .foregroundColor(Color(UIColor.systemGray2))
                                .frame(width: 150)
                                .opacity(0.4)

                        }.offset(x: 100, y: 0)
                    }
                }
                .cornerRadius(5)
                .frame(height: 200)
            }

        }
        .redacted(when: viewModel.workoutRouteLoading)

    }

}

//
//struct FeaturedWorkout_Previews: PreviewProvider {
//    static var previews: some View {
//        FeaturedWorkout(workout: HKWorkout(activityType: .running, start: Date(), end: Date()))
//    }
//}
