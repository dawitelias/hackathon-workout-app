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
            .bowling,
            .boxing,
            .climbing,
            .crossTraining,
            .curling,
            .cycling,
            .dance,
            .elliptical,
            .equestrianSports,
            .fencing,
            .fishing,
            .functionalStrengthTraining,
            .golf,
            .gymnastics,
            .handball,
            .hiking,
            .hockey,
            .hunting,
            .lacrosse,
            .martialArts,
            .mindAndBody,
            .paddleSports,
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
            .squash,
            .stairClimbing,
            .surfingSports,
            .swimming,
            .tableTennis,
            .trackAndField,
            .traditionalStrengthTraining,
            .volleyball,
            .walking,
            .waterFitness,
            .waterPolo,
            .waterSports,
            .wrestling,
            .yoga,
            .barre,
            .coreTraining,
            .crossCountrySkiing,
            .downhillSkiing,
            .flexibility,
            .highIntensityIntervalTraining,
            .jumpRope,
            .kickboxing,
            .pilates,
            .snowboarding,
            .stairs,
            .stepTraining,
            .wheelchairWalkPace,
            .wheelchairRunPace,
            .taiChi,
            .mixedCardio,
            .handCycling,
            .discSports,
            .fitnessGaming
        ]
    }

    /*
     Simple mapping of available workout types to a human readable name.
     */
    var workoutTypeMetadata: WorkoutTypeMetadata {
        switch self {
        case .americanFootball:
            return WorkoutTypeMetadata(icon: "person.fill", description: "American Football")
        case .archery:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Archery")
        case .australianFootball:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Australian Football")
        case .badminton:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Badmiton")
        case .baseball:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Baseball")
        case .basketball:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Basketball")
        case .bowling:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Bowling")
        case .boxing:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Boxing")
        case .climbing:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Climbing")
        case .crossTraining:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Cross Training")
        case .curling:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Curling")
        case .cycling:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Cycling")
        case .dance:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Dance")
        case .elliptical:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Elliptical")
        case .equestrianSports:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Equestrian Sports")
        case .fencing:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Fencing")
        case .fishing:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Fishing")
        case .functionalStrengthTraining:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Strength Training")
        case .golf:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Golf")
        case .gymnastics:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Gymnastics")
        case .handball:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Handball")
        case .hiking:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Hiking")
        case .hockey:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Hockey")
        case .hunting:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Hunting")
        case .lacrosse:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Lacrosse")
        case .martialArts:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Martial Arts")
        case .mindAndBody:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Mind and Body")
        case .paddleSports:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Paddle Sports")
        case .play:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Play")
        case .preparationAndRecovery:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Preparation and Recovery")
        case .racquetball:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Raquetball")
        case .rowing:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Rowing")
        case .rugby:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Rugby")
        case .running:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Running")
        case .sailing:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Sailing")
        case .skatingSports:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Skating Sports")
        case .snowSports:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Snow Sports")
        case .soccer:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Soccer")
        case .softball:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Softball")
        case .squash:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Squash")
        case .stairClimbing:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Stair Climbing")
        case .surfingSports:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Surfing Sports")
        case .swimming:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Swimming")
        case .tableTennis:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Table Tennis")
        case .tennis:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Tennis")
        case .trackAndField:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Track and Field")
        case .traditionalStrengthTraining:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Traditional Strength Training")
        case .volleyball:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Volleyball")
        case .walking:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Walking")
        case .waterFitness:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Water Fitness")
        case .waterPolo:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Water Polo")
        case .waterSports:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Water Sports")
        case .wrestling:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Wrestling")
        case .yoga:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Yoga")
        case .barre:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Barre")
        case .coreTraining:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Core Training")
        case .crossCountrySkiing:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Cross Country Skiing")
        case .downhillSkiing:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Downhill Skiing")
        case .flexibility:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Flexibility")
        case .highIntensityIntervalTraining:
            return WorkoutTypeMetadata(icon: "person.fill", description: "HIIT")
        case .jumpRope:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Jump Rope")
        case .kickboxing:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Kickboxing")
        case .pilates:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Pilates")
        case .snowboarding:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Snowboarding")
        case .stairs:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Stairs")
        case .stepTraining:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Step Training")
        case .wheelchairWalkPace:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Wheelchair Walk Pace")
        case .wheelchairRunPace:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Wheelchair Run Pace")
        case .taiChi:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Tai Chi")
        case .mixedCardio:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Mixed Cardio")
        case .handCycling:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Hand Cycling")
        case .discSports:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Disc Sports")
        case .fitnessGaming:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Fitness Gaming")
        default:
            return WorkoutTypeMetadata(icon: "person.fill", description: "Other")
        }
    }

}
