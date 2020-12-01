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
import SwiftUICharts

var generatedMapImageTwo: UIImage = UIImage()

struct WorkoutDetail: View {

    let viewModel: WorkoutDetailViewModel

    @State var selectedChart: Int = 2 // HR Chart selected by default

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        // MARK: Custom chart styles
        //
        let heartRateChartStyle = ChartStyle(backgroundColor: Color(UIColor.systemBackground), accentColor: viewModel.highlightColor, gradientColor: GradientColor(start: Color("AL_1"), end: Color("AQ_1")), textColor: Color(UIColor.label), legendTextColor: Color(UIColor.secondaryLabel), dropShadowColor: Color(UIColor.systemFill))

        let speedChartStyle = ChartStyle(backgroundColor: Color(UIColor.systemBackground), accentColor: viewModel.highlightColor, gradientColor: GradientColor(start: Color("AQ_1"), end: Color("B_1")), textColor: Color(UIColor.label), legendTextColor: Color(UIColor.secondaryLabel), dropShadowColor: Color(UIColor.systemFill))

        let elevationChartStyle = ChartStyle(backgroundColor: Color(UIColor.systemBackground), accentColor: viewModel.highlightColor, gradientColor: GradientColor(start: Color("AQ_1"), end: Color("B_1")), textColor: Color(UIColor.label), legendTextColor: Color(UIColor.secondaryLabel), dropShadowColor: Color(UIColor.systemFill))
        
        return ScrollView {

            VStack(alignment: .leading) {

                HStack {

                    Icon(image: Image(viewModel.iconName), mainColor: viewModel.mainColor, highlightColor: viewModel.highlightColor, size: 50)
                        .padding()

                    VStack(alignment: .leading) {

                        HStack {
                            Text("\(viewModel.workout.startDate.weekday), \(viewModel.workout.startDate.date)")
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                        }
                        
                        Text("\(viewModel.workoutHoursAndMinutes) 🔥")
                            .font(.system(.largeTitle, design: .rounded))
                    }
                }
                HStack {
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Total Time")
                        Text(viewModel.workoutTimerDescription)
                            .font(.title)
                            .fontWeight(.regular)
                            .minimumScaleFactor(0.01)
                            .foregroundColor(viewModel.mainColor)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Calories")
                        Text(viewModel.numberOfCaloriesBurned)
                            .font(.title)
                            .fontWeight(.regular)
                            .minimumScaleFactor(0.01)
                            .foregroundColor(viewModel.mainColor)
                    }
                    Spacer()
                    if viewModel.route != nil && viewModel.route!.count != 0 {
                        VStack(alignment: .leading) {
                            Text("Distance")
                            Text(viewModel.workoutDistanceDescription)
                                .font(.title)
                                .fontWeight(.regular)
                                .minimumScaleFactor(0.01)
                                .foregroundColor(viewModel.mainColor)
                        }
                    }
                    Spacer()
                }

                // Render a map showing route data if the workout HAS route data...
                //
                if viewModel.route != nil && viewModel.route!.count != 0 {

                    VStack(alignment: .leading) {

                        NavigationLink(destination: FullScreenMapView(route: viewModel.route!)) {

                            ZStack(alignment: .topTrailing) {

                                if viewModel.workout.getImageFromDocumentsDirectory(colorScheme: colorScheme) != nil {

                                    Image(uiImage: viewModel.workout.getImageFromDocumentsDirectory(colorScheme: colorScheme)!)
                                        .resizable()
                                        .frame(height: 200)
                                        .cornerRadius(20)

                                } else {

                                    EsriMapCard(workout: viewModel.workout, route: viewModel.route!)
                                        .frame(width: nil, height: 200, alignment: .center)
                                        .cornerRadius(20)

                                }
                                // Shows the
                                ZStack {
                                    Circle()
                                        .foregroundColor(Color(UIColor.label.withAlphaComponent(0.8)))

                                    Image(systemName: "rectangle.and.arrow.up.right.and.arrow.down.left")
                                        .resizable()
                                        .foregroundColor(viewModel.mainColor)
                                        .frame(width: 18, height: 23)
                                        .padding()
                                }
                                .frame(width: 25, height: 25)
                                .padding(20)

                            }
                            
                        }.buttonStyle(PlainButtonStyle())
                        
                    }
                    .padding(.leading, 5)
                    .padding(.trailing, 5)
                }
            
                // Show pace data, elevation data and HR data
                //
                VStack(alignment: .leading) {
//                    if selectedChart == 0 && viewModel.route != nil {
//                        VStack {
//                            ElevationChart(routeData: route!)
//                        }.frame(width: nil, height: 150)
//                    }

                    // MARK: Speed Chart
                    //
                    if selectedChart == 1 {

                        LineView(data: viewModel.speedData, title: "Speed (MPH)", style: speedChartStyle, valueSpecifier: "%.2f")
                            .frame(width: nil, height: 350)
                            .padding(.horizontal)

                    }

                    // MARK: Heart Rate Chart
                    //
                    
                    if selectedChart == 2 {

                        if viewModel.errorFetchingWorkoutHRData {

                            VStack(alignment: .center, spacing: 5) {
                                Text("There was an error loading the workout heart rate data.")
                                Button("Retry Load") { viewModel.retryLoadWorkoutHeartRateData() }
                            }.padding()

                        } else if let simplifiedHRData = viewModel.simplifiedHRData, simplifiedHRData.count > 2 {

                            LineView(data: simplifiedHRData.map { $0.reading }, title: "Heart Rate (BPM)", style: heartRateChartStyle, valueSpecifier: "%.0f")
                                .frame(width: nil, height: 350)
                                .padding(.horizontal)

                        } else if let simplifiedHRData = viewModel.simplifiedHRData, simplifiedHRData.count > 2 {

                            Text("No heart rate data for this workout.")

                        } else {

                            Text("Heart rate data is loading.")

                        }

                    }

                    Picker(selection: $selectedChart, label: Text("Pick")) {

                        if viewModel.altitudeData != nil {
                            Text("Elevation").tag(0)
                        }

                        if viewModel.velocityData != nil {
                            Text("Speed").tag(1)
                        }

                        if let workoutHRData = viewModel.workoutHRData, workoutHRData.count > 0 {
                            Text("Heart Rate").tag(2)
                        }

                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()

                }.padding(.top, 20)
            }
        }
        .navigationBarTitle(Text(viewModel.workout.workoutActivityType.workoutTypeMetadata.activityTypeDescription), displayMode: .large)
    }
}

struct WorkoutDetail_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutDetail(viewModel: WorkoutDetailViewModel(workout: HKWorkout(activityType: .running, start: Date(), end: Date())))
    }
}
