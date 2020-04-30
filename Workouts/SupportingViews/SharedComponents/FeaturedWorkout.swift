//
//  FeaturedWorkout.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/16/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI
import HealthKit

struct FeaturedWorkout: View {
    var workout: HKWorkout
    @State var workoutHasRouteData = false

    var body: some View {
        workout.getWorkoutLocationData() { results, error in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            if let locations = results {
                if locations.count > 0 {
                    self.workoutHasRouteData = true
                }
            }
        }
        
        return VStack(alignment: .leading) {
            HStack {
                CircleImage(image: Image(workout.workoutActivityType.workoutTypeMetadata.systemIconName))
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
            if workoutHasRouteData {
                MapView(workout: workout, startAnnotation: StartAnnotation(), endAnnotation: EndAnnotation())
                    .frame(height: 200)
                    .padding(.horizontal, -15)
                    .padding(.bottom, -6)
            } else {
                Image("goodWork") // temporary image until we decide what to do artwise here. I have a few ideas.
                    .resizable()
                    .frame(height: 200)
                    .padding(.horizontal, -15)
                    .padding(.bottom, -6)
            }
            
        }
    }

}

struct FeaturedWorkout_Previews: PreviewProvider {
    static var previews: some View {
        FeaturedWorkout(workout: HKWorkout(activityType: .running, start: Date(), end: Date()))
    }
}
