//
//  HKWorkoutActivityType+Extension.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/16/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import Foundation
import HealthKit
import SwiftUI

struct WorkoutTypeMetadata {
    var systemIconName: String
    var activityTypeDescription: String
    var activityColor: Color
    
    init(icon: String, description: String, color: Color) {
        self.systemIconName = icon
        self.activityTypeDescription = description
        self.activityColor = color
    }
}

extension HKWorkoutActivityType {
    
    // Thanks to Apple for not letting HKWorkoutActivity type extend CaseIterable OR String
    //
    static var allCases: [HKWorkoutActivityType] {
        return [
            .americanFootball,
            .archery,
            .australianFootball,
            .badminton,
            .baseball,
            .basketball,
            .barre,
            .bowling,
            .boxing,
            .climbing,
            .coreTraining,
            .crossCountrySkiing,
            .crossTraining,
            .curling,
            .cycling,
            .dance,
            .discSports,
            .downhillSkiing,
            .elliptical,
            .equestrianSports,
            .fencing,
            .fishing,
            .fitnessGaming,
            .flexibility,
            .functionalStrengthTraining,
            .golf,
            .gymnastics,
            .handball,
            .handCycling,
            .hiking,
            .highIntensityIntervalTraining,
            .hockey,
            .hunting,
            .jumpRope,
            .kickboxing,
            .lacrosse,
            .martialArts,
            .mindAndBody,
            .mixedCardio,
            .paddleSports,
            .pilates,
            .play,
            .preparationAndRecovery,
            .racquetball,
            .rowing,
            .rugby,
            .running,
            .sailing,
            .skatingSports,
            .snowSports,
            .soccer,
            .softball,
            .snowboarding,
            .squash,
            .stairs,
            .stairClimbing,
            .stepTraining,
            .surfingSports,
            .swimming,
            .tableTennis,
            .taiChi,
            .trackAndField,
            .traditionalStrengthTraining,
            .volleyball,
            .walking,
            .waterFitness,
            .waterPolo,
            .waterSports,
            .wheelchairWalkPace,
            .wheelchairRunPace,
            .wrestling,
            .yoga
        ]
    }

    /*
     Simple mapping of available workout types to a human readable name.
     Colors: *** These are randomly being pulled from a pool of about 10 different colors - these will not be random in the future.
     Not using these anywhere at the moment, but have plans to do so.
     */
    var workoutTypeMetadata: WorkoutTypeMetadata {
        switch self {
        case .americanFootball:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "American Football",
                color: Color.getFlatUIColor())
        case .archery:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Archery",
                color: Color.getFlatUIColor())
        case .australianFootball:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Australian Football",
                color: Color.getFlatUIColor())
        case .badminton:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Badmiton",
                color: Color.getFlatUIColor())
        case .baseball:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Baseball",
                color: Color.getFlatUIColor())
        case .basketball:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Basketball",
                color: Color.getFlatUIColor())
        case .bowling:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Bowling",
                color: Color.getFlatUIColor())
        case .boxing:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Boxing",
                color: Color.getFlatUIColor())
        case .climbing:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Climbing",
                color: Color.getFlatUIColor())
        case .crossTraining:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Cross Training",
                color: Color.getFlatUIColor())
        case .curling:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Curling",
                color: Color.getFlatUIColor())
        case .cycling:
            return WorkoutTypeMetadata(
                icon: "Biking",
                description: "Cycling",
                color: Color.getFlatUIColor())
        case .dance:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Dance",
                color: Color.getFlatUIColor())
        case .elliptical:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Elliptical",
                color: Color.getFlatUIColor())
        case .equestrianSports:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Equestrian Sports",
                color: Color.getFlatUIColor())
        case .fencing:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Fencing",
                color: Color.getFlatUIColor())
        case .fishing:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Fishing",
                color: Color.getFlatUIColor())
        case .functionalStrengthTraining:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Strength Training",
                color: Color.getFlatUIColor())
        case .golf:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Golf",
                color: Color.getFlatUIColor())
        case .gymnastics:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Gymnastics",
                color: Color.getFlatUIColor())
        case .handball:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Handball",
                color: Color.getFlatUIColor())
        case .hiking:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Hiking",
                color: Color.getFlatUIColor())
        case .hockey:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Hockey",
                color: Color.getFlatUIColor())
        case .hunting:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Hunting",
                color: Color.getFlatUIColor())
        case .lacrosse:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Lacrosse",
                color: Color.getFlatUIColor())
        case .martialArts:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Martial Arts",
                color: Color.getFlatUIColor())
        case .mindAndBody:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Mind and Body",
                color: Color.getFlatUIColor())
        case .paddleSports:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Paddle Sports",
                color: Color.getFlatUIColor())
        case .play:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Play",
                color: Color.getFlatUIColor())
        case .preparationAndRecovery:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Preparation and Recovery",
                color: Color.getFlatUIColor())
        case .racquetball:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Raquetball",
                color: Color.getFlatUIColor())
        case .rowing:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Rowing",
                color: Color.getFlatUIColor())
        case .rugby:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Rugby",
                color: Color.getFlatUIColor())
        case .running:
            return WorkoutTypeMetadata(
                icon: "Running",
                description: "Running",
                color: Color.getFlatUIColor())
        case .sailing:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Sailing",
                color: Color.getFlatUIColor())
        case .skatingSports:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Skating Sports",
                color: Color.getFlatUIColor())
        case .snowSports:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Snow Sports",
                color: Color.getFlatUIColor())
        case .soccer:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Soccer",
                color: Color.getFlatUIColor())
        case .softball:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Softball",
                color: Color.getFlatUIColor())
        case .squash:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Squash",
                color: Color.getFlatUIColor())
        case .stairClimbing:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Stair Climbing",
                color: Color.getFlatUIColor())
        case .surfingSports:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Surfing Sports",
                color: Color.getFlatUIColor())
        case .swimming:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Swimming",
                color: Color.getFlatUIColor())
        case .tableTennis:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Table Tennis",
                color: Color.getFlatUIColor())
        case .tennis:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Tennis",
                color: Color.getFlatUIColor())
        case .trackAndField:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Track and Field",
                color: Color.getFlatUIColor())
        case .traditionalStrengthTraining:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Traditional Strength Training",
                color: Color.getFlatUIColor())
        case .volleyball:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Volleyball",
                color: Color.getFlatUIColor())
        case .walking:
            return WorkoutTypeMetadata(
                icon: "Walking",
                description: "Walking",
                color: Color.getFlatUIColor())
        case .waterFitness:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Water Fitness",
                color: Color.getFlatUIColor())
        case .waterPolo:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Water Polo",
                color: Color.getFlatUIColor())
        case .waterSports:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Water Sports",
                color: Color.getFlatUIColor())
        case .wrestling:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Wrestling",
                color: Color.getFlatUIColor())
        case .yoga:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Yoga",
                color: Color.getFlatUIColor())
        case .barre:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Barre",
                color: Color.getFlatUIColor())
        case .coreTraining:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Core Training",
                color: Color.getFlatUIColor())
        case .crossCountrySkiing:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Cross Country Skiing",
                color: Color.getFlatUIColor())
        case .downhillSkiing:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Downhill Skiing",
                color: Color.getFlatUIColor())
        case .flexibility:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Flexibility",
                color: Color.getFlatUIColor())
        case .highIntensityIntervalTraining:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "HIIT",
                color: Color.getFlatUIColor())
        case .jumpRope:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Jump Rope",
                color: Color.getFlatUIColor())
        case .kickboxing:
            return WorkoutTypeMetadata(
                icon: "Kickboxing",
                description: "Kickboxing",
                color: Color.getFlatUIColor())
        case .pilates:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Pilates",
                color: Color.getFlatUIColor())
        case .snowboarding:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Snowboarding",
                color: Color.getFlatUIColor())
        case .stairs:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Stairs",
                color: Color.getFlatUIColor())
        case .stepTraining:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Step Training",
                color: Color.getFlatUIColor())
        case .wheelchairWalkPace:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Wheelchair Walk Pace",
                color: Color.getFlatUIColor())
        case .wheelchairRunPace:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Wheelchair Run Pace",
                color: Color.getFlatUIColor())
        case .taiChi:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Tai Chi",
                color: Color.getFlatUIColor())
        case .mixedCardio:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Mixed Cardio",
                color: Color.getFlatUIColor())
        case .handCycling:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Hand Cycling",
                color: Color.getFlatUIColor())
        case .discSports:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Disc Sports",
                color: Color.getFlatUIColor())
        case .fitnessGaming:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Fitness Gaming",
                color: Color.getFlatUIColor())
        default:
            return WorkoutTypeMetadata(
                icon: "Kettlebell",
                description: "Other",
                color: Color.getFlatUIColor())
        }
    }

}
