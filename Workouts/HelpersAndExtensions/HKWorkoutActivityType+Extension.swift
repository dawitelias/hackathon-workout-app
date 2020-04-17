//
//  HKWorkoutActivityType+Extension.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/16/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import Foundation
import HealthKit

struct WorkoutTypeMetadata {
    var systemIconName: String
    var activityTypeDescription: String
    
    init(icon: String, description: String) {
        self.systemIconName = icon
        self.activityTypeDescription = description
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
     */
    var workoutTypeMetadata: WorkoutTypeMetadata {
        switch self {
        case .americanFootball:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "American Football")
        case .archery:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Archery")
        case .australianFootball:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Australian Football")
        case .badminton:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Badmiton")
        case .baseball:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Baseball")
        case .basketball:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Basketball")
        case .bowling:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Bowling")
        case .boxing:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Boxing")
        case .climbing:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Climbing")
        case .crossTraining:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Cross Training")
        case .curling:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Curling")
        case .cycling:
            return WorkoutTypeMetadata(icon: "Biking", description: "Cycling")
        case .dance:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Dance")
        case .elliptical:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Elliptical")
        case .equestrianSports:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Equestrian Sports")
        case .fencing:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Fencing")
        case .fishing:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Fishing")
        case .functionalStrengthTraining:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Strength Training")
        case .golf:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Golf")
        case .gymnastics:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Gymnastics")
        case .handball:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Handball")
        case .hiking:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Hiking")
        case .hockey:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Hockey")
        case .hunting:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Hunting")
        case .lacrosse:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Lacrosse")
        case .martialArts:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Martial Arts")
        case .mindAndBody:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Mind and Body")
        case .paddleSports:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Paddle Sports")
        case .play:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Play")
        case .preparationAndRecovery:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Preparation and Recovery")
        case .racquetball:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Raquetball")
        case .rowing:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Rowing")
        case .rugby:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Rugby")
        case .running:
            return WorkoutTypeMetadata(icon: "Running", description: "Running")
        case .sailing:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Sailing")
        case .skatingSports:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Skating Sports")
        case .snowSports:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Snow Sports")
        case .soccer:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Soccer")
        case .softball:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Softball")
        case .squash:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Squash")
        case .stairClimbing:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Stair Climbing")
        case .surfingSports:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Surfing Sports")
        case .swimming:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Swimming")
        case .tableTennis:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Table Tennis")
        case .tennis:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Tennis")
        case .trackAndField:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Track and Field")
        case .traditionalStrengthTraining:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Traditional Strength Training")
        case .volleyball:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Volleyball")
        case .walking:
            return WorkoutTypeMetadata(icon: "Walking", description: "Walking")
        case .waterFitness:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Water Fitness")
        case .waterPolo:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Water Polo")
        case .waterSports:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Water Sports")
        case .wrestling:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Wrestling")
        case .yoga:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Yoga")
        case .barre:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Barre")
        case .coreTraining:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Core Training")
        case .crossCountrySkiing:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Cross Country Skiing")
        case .downhillSkiing:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Downhill Skiing")
        case .flexibility:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Flexibility")
        case .highIntensityIntervalTraining:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "HIIT")
        case .jumpRope:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Jump Rope")
        case .kickboxing:
            return WorkoutTypeMetadata(icon: "Kickboxing", description: "Kickboxing")
        case .pilates:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Pilates")
        case .snowboarding:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Snowboarding")
        case .stairs:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Stairs")
        case .stepTraining:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Step Training")
        case .wheelchairWalkPace:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Wheelchair Walk Pace")
        case .wheelchairRunPace:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Wheelchair Run Pace")
        case .taiChi:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Tai Chi")
        case .mixedCardio:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Mixed Cardio")
        case .handCycling:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Hand Cycling")
        case .discSports:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Disc Sports")
        case .fitnessGaming:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Fitness Gaming")
        default:
            return WorkoutTypeMetadata(icon: "Kettlebell", description: "Other")
        }
    }

}
