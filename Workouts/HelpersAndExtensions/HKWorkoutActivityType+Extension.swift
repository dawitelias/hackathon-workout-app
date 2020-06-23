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
    var mainColor: Color
    var highlightColor: Color
    
    init(icon: String, description: String, mainColor: Color, highlightColor: Color) {
        self.systemIconName = icon
        self.activityTypeDescription = description
        self.mainColor = mainColor
        self.highlightColor = highlightColor
    }
}

extension HKWorkoutActivityType {
    
    // Thanks to Apple for not letting HKWorkoutActivity type extend CaseIterable OR String
    //
    static var allCases: [HKWorkoutActivityType] {
        return [

            // Sports
            //
            .americanFootball,
            .australianFootball,
            .volleyball,
            .badminton,
            .baseball,
            .basketball,
            .hockey,
            .soccer,
            .lacrosse,
            .golf,
            .softball,
            .bowling,
            .racquetball,
            .rowing,
            .rugby,
            .discSports,
            .curling,
            .equestrianSports,
            .fencing,
            .squash,
            .tableTennis,
            .handball,
            .tennis,
            
            // Outdoorsy things
            //
            .archery,
            .hunting,
            .fishing,
            .climbing,
            
            // Random - Purples
            //
            .play,
            .fitnessGaming,
            
            // Gym Rat Activities - Oranges
            //
            .highIntensityIntervalTraining,
            .coreTraining,
            .crossTraining,
            .preparationAndRecovery,
            .flexibility,
            .functionalStrengthTraining,
            .traditionalStrengthTraining,
            
            // Snow Sports - Blues
            //
            .skatingSports,
            .snowSports,
            .downhillSkiing,
            .crossCountrySkiing,
            .snowboarding,
            
            // Water Sports - Blues
            //
            .swimming,
            .sailing,
            .surfingSports,
            .waterFitness,
            .waterSports,
            .waterPolo,
            .paddleSports,
            
            // Coordinated things
            //
            .wrestling,
            .yoga,
            .barre,
            .boxing,
            .taiChi,
            .dance,
            .martialArts,
            .mindAndBody,
            .gymnastics,
            .pilates,
            .jumpRope,
            .kickboxing,
            
            // Cardio
            //
            .walking,
            .trackAndField,
            .hiking,
            .cycling,
            .running,
            .mixedCardio,
            .elliptical,
            .stairs,
            .stairClimbing,
            .stepTraining,
            .handCycling,
            
            // Wheelchair
            //
            .wheelchairWalkPace,
            .wheelchairRunPace,
        ]
    }

    /*
     Simple mapping of available workout types to a human readable name.
     Colors: *** These are randomly being pulled from a pool of about 10 different colors - these will not be random in the future.
     Not using these anywhere at the moment, but have plans to do so.
     */
    var workoutTypeMetadata: WorkoutTypeMetadata {
        switch self {
        // Sports
        //
        case .americanFootball:
            return WorkoutTypeMetadata(
                icon: "Football",
                description: "American Football",
                mainColor: Color("A_1"),
                highlightColor: Color("A_2"))
        case .australianFootball:
            return WorkoutTypeMetadata(
                icon: "Football",
                description: "Australian Football",
                mainColor: Color("B_1"),
                highlightColor: Color("B_2"))
        case .volleyball:
            return WorkoutTypeMetadata(
                icon: "Volleyball",
                description: "Volleyball",
                mainColor: Color("C_1"),
                highlightColor: Color("C_2"))
        case .badminton:
            return WorkoutTypeMetadata(
                icon: "Badminton",
                description: "Badminton",
                mainColor: Color("D_1"),
                highlightColor: Color("D_2"))
        case .baseball:
            return WorkoutTypeMetadata(
                icon: "Baseball",
                description: "Baseball",
                mainColor: Color("E_1"),
                highlightColor: Color("E_2"))
        case .basketball:
            return WorkoutTypeMetadata(
                icon: "Basketball",
                description: "Basketball",
                mainColor: Color("F_1"),
                highlightColor: Color("F_2"))
        case .hockey:
            return WorkoutTypeMetadata(
                icon: "Hockey",
                description: "Hockey",
                mainColor: Color("G_1"),
                highlightColor: Color("G_2"))
        case .soccer:
            return WorkoutTypeMetadata(
                icon: "Soccer",
                description: "Soccer",
                mainColor: Color("H_1"),
                highlightColor: Color("H_2"))
        case .lacrosse:
            return WorkoutTypeMetadata(
                icon: "Lacrosse",
                description: "Lacrosse",
                mainColor: Color("I_1"),
                highlightColor: Color("I_2"))
        case .golf:
            return WorkoutTypeMetadata(
                icon: "Golf",
                description: "Golf",
                mainColor: Color("J_1"),
                highlightColor: Color("J_2"))
        case .softball:
            return WorkoutTypeMetadata(
                icon: "Softball",
                description: "Softball",
                mainColor: Color("K_1"),
                highlightColor: Color("K_2"))
        case .bowling:
            return WorkoutTypeMetadata(
                icon: "Bowling",
                description: "Bowling",
                mainColor: Color("L_1"),
                highlightColor: Color("L_2"))
        case .racquetball:
            return WorkoutTypeMetadata(
                icon: "RacquetBall",
                description: "Raquetball",
                mainColor: Color("M_1"),
                highlightColor: Color("M_2"))
        case .rowing:
            return WorkoutTypeMetadata(
                icon: "Rowing",
                description: "Rowing",
                mainColor: Color("N_1"),
                highlightColor: Color("N_2"))
        case .rugby:
           return WorkoutTypeMetadata(
               icon: "Rugby",
               description: "Rugby",
               mainColor: Color("O_1"),
               highlightColor: Color("O_2"))
        case .discSports:
            return WorkoutTypeMetadata(
                icon: "DiscSports",
                description: "Disc Sports",
                mainColor: Color("P_1"),
                highlightColor: Color("P_2"))
        case .curling:
            return WorkoutTypeMetadata(
                icon: "Curling",
                description: "Curling",
                mainColor: Color("Q_1"),
                highlightColor: Color("Q_2"))
        case .equestrianSports:
            return WorkoutTypeMetadata(
                icon: "EquestrianSports",
                description: "Equestrian Sports",
                mainColor: Color("R_1"),
                highlightColor: Color("R_2"))
        case .fencing:
            return WorkoutTypeMetadata(
                icon: "Fencing",
                description: "Fencing",
                mainColor: Color("S_1"),
                highlightColor: Color("S_2"))
        case .squash:
            return WorkoutTypeMetadata(
                icon: "Squash",
                description: "Squash",
                mainColor: Color("T_1"),
                highlightColor: Color("T_2"))
        case .tableTennis:
           return WorkoutTypeMetadata(
               icon: "TableTennis",
               description: "Table Tennis",
               mainColor: Color("U_1"),
               highlightColor: Color("U_2"))
        case .handball:
            return WorkoutTypeMetadata(
                icon: "HandBall",
                description: "Handball",
                mainColor: Color("V_1"),
                highlightColor: Color("V_2"))
        case .tennis:
            return WorkoutTypeMetadata(
                icon: "RacquetBall",
                description: "Tennis",
                mainColor: Color("W_1"),
                highlightColor: Color("W_2"))
            
        // Outdoorsy Things
        //
        case .archery:
            return WorkoutTypeMetadata(
                icon: "Archery",
                description: "Archery",
                mainColor: Color("F_1"),
                highlightColor: Color("F_2"))
        case .hunting:
            return WorkoutTypeMetadata(
                icon: "Hunting",
                description: "Hunting",
                mainColor: Color("G_1"),
                highlightColor: Color("G_2"))
        case .fishing:
            return WorkoutTypeMetadata(
                icon: "Fishing",
                description: "Fishing",
                mainColor: Color("H_1"),
                highlightColor: Color("H_2"))
        case .climbing:
            return WorkoutTypeMetadata(
                icon: "Climbing",
                description: "Climbing",
                mainColor: Color("I_1"),
                highlightColor: Color("I_2"))
        
        // Other
        //
        case .play:
            return WorkoutTypeMetadata(
                icon: "Play",
                description: "Play",
                mainColor: Color("AM_1"),
                highlightColor: Color("AM_2"))
        case .fitnessGaming:
            return WorkoutTypeMetadata(
                icon: "FitnessGaming",
                description: "Fitness Gaming",
                mainColor: Color("AN_1"),
                highlightColor: Color("AN_2"))
        
        // Gym Rat Activities
        //
        case .highIntensityIntervalTraining:
            return WorkoutTypeMetadata(
                icon: "Hiit",
                description: "HIIT",
                mainColor: Color("AJ_1"),
                highlightColor: Color("AJ_2"))
        case .coreTraining:
            return WorkoutTypeMetadata(
                icon: "CoreTraining",
                description: "Core Training",
                mainColor: Color("AK_1"),
                highlightColor: Color("AK_2"))
        case .crossTraining:
            return WorkoutTypeMetadata(
                icon: "Elliptical",
                description: "Cross Training",
                mainColor: Color("AL_1"),
                highlightColor: Color("AL_2"))
        case .preparationAndRecovery:
            return WorkoutTypeMetadata(
                icon: "MindAndBody",
                description: "Preparation and Recovery",
                mainColor: Color("AW_1"),
                highlightColor: Color("AW_2"))
        case .flexibility:
            return WorkoutTypeMetadata(
                icon: "Yoga",
                description: "Flexibility",
                mainColor: Color("AX_1"),
                highlightColor: Color("AX_2"))
        case .functionalStrengthTraining:
            return WorkoutTypeMetadata(
                icon: "StrengthTraining",
                description: "Strength Training",
                mainColor: Color("AY_1"),
                highlightColor: Color("AY_2"))
        case .traditionalStrengthTraining:
            return WorkoutTypeMetadata(
                icon: "StrengthTraining",
                description: "Traditional Strength Training",
                mainColor: Color("AZ_1"),
                highlightColor: Color("AZ_2"))

        // Snow Sports
        //
        case .skatingSports:
            return WorkoutTypeMetadata(
                icon: "Skating",
                description: "Skating Sports",
                mainColor: Color("Z_1"),
                highlightColor: Color("Z_2"))
        case .snowSports:
            return WorkoutTypeMetadata(
                icon: "SnowSports",
                description: "Snow Sports",
                mainColor: Color("AA_1"),
                highlightColor: Color("AA_2"))
        case .downhillSkiing:
            return WorkoutTypeMetadata(
                icon: "DownhillSkiing",
                description: "Downhill Skiing",
                mainColor: Color("AB_1"),
                highlightColor: Color("AB_2"))
        case .crossCountrySkiing:
            return WorkoutTypeMetadata(
                icon: "CrossCountrySkiing",
                description: "Cross Country Skiing",
                mainColor: Color("AC_1"),
                highlightColor: Color("AC_2"))
        case .snowboarding:
            return WorkoutTypeMetadata(
                icon: "Snowboarding",
                description: "Snowboarding",
                mainColor: Color("AD_1"),
                highlightColor: Color("AD_2"))

        // Water Sports
        //
        case .swimming:
            return WorkoutTypeMetadata(
                icon: "Swimming",
                description: "Swimming",
                mainColor: Color("S_1"),
                highlightColor: Color("S_2"))
        case .sailing:
            return WorkoutTypeMetadata(
                icon: "Sailing",
                description: "Sailing",
                mainColor: Color("T_1"),
                highlightColor: Color("T_2"))
        case .surfingSports:
            return WorkoutTypeMetadata(
                icon: "Surfing",
                description: "Surfing Sports",
                mainColor: Color("U_1"),
                highlightColor: Color("U_2"))
        case .waterFitness:
            return WorkoutTypeMetadata(
                icon: "WaterSports",
                description: "Water Fitness",
                mainColor: Color("V_1"),
                highlightColor: Color("V_2"))
        case .waterPolo:
            return WorkoutTypeMetadata(
                icon: "WaterPolo",
                description: "Water Polo",
                mainColor: Color("W_1"),
                highlightColor: Color("W_2"))
        case .paddleSports:
            return WorkoutTypeMetadata(
                icon: "PaddleSports",
                description: "Paddle Sports",
                mainColor: Color("X_1"),
                highlightColor: Color("X_2"))
        case .waterSports:
            return WorkoutTypeMetadata(
                icon: "WaterSports",
                description: "Water Sports",
                mainColor: Color("Y_1"),
                highlightColor: Color("Y_2"))
                
        // Coordinated things
        //
        case .wrestling:
            return WorkoutTypeMetadata(
                icon: "Wrestling",
                description: "Wrestling",
                mainColor: Color("AO_1"),
                highlightColor: Color("AO_2"))
        case .yoga:
            return WorkoutTypeMetadata(
                icon: "Yoga",
                description: "Yoga",
                mainColor: Color("AP_1"),
                highlightColor: Color("AP_2"))
        case .barre:
            return WorkoutTypeMetadata(
                icon: "TaiChi",
                description: "Barre",
                mainColor: Color("AQ_1"),
                highlightColor: Color("AQ_2"))
        case .boxing:
            return WorkoutTypeMetadata(
                icon: "Boxing",
                description: "Boxing",
                mainColor: Color("AR_1"),
                highlightColor: Color("AR_2"))
        case .taiChi:
            return WorkoutTypeMetadata(
                icon: "TaiChi",
                description: "Tai Chi",
                mainColor: Color("AS_1"),
                highlightColor: Color("AS_2"))
        case .dance:
            return WorkoutTypeMetadata(
                icon: "Dance",
                description: "Dance",
                mainColor: Color("AT_1"),
                highlightColor: Color("AT_2"))
        case .martialArts:
            return WorkoutTypeMetadata(
                icon: "MartialArts",
                description: "Martial Arts",
                mainColor: Color("AU_1"),
                highlightColor: Color("AU_2"))
        case .mindAndBody:
            return WorkoutTypeMetadata(
                icon: "MindAndBody",
                description: "Mind and Body",
                mainColor: Color("AV_1"),
                highlightColor: Color("AV_2"))
        case .gymnastics:
            return WorkoutTypeMetadata(
                icon: "Gymnastics",
                description: "Gymnastics",
                mainColor: Color("AE_1"),
                highlightColor: Color("AE_2"))
        case .pilates:
            return WorkoutTypeMetadata(
                icon: "Pilates",
                description: "Pilates",
                mainColor: Color("AF_1"),
                highlightColor: Color("AF_2"))
        case .jumpRope:
            return WorkoutTypeMetadata(
                icon: "JumpRope",
                description: "Jump Rope",
                mainColor: Color("AG_1"),
                highlightColor: Color("AG_2"))
        case .kickboxing:
            return WorkoutTypeMetadata(
                icon: "KickBoxing",
                description: "Kickboxing",
                mainColor: Color("AH_1"),
                highlightColor: Color("AH_2"))
            
        // Cardio
        //
        case .walking:
             return WorkoutTypeMetadata(
                 icon: "Walking",
                 description: "Walking",
                 mainColor: Color("AE_1"),
                 highlightColor: Color("AE_2"))
         case .trackAndField:
             return WorkoutTypeMetadata(
                 icon: "TrackAndField",
                 description: "Track and Field",
                 mainColor: Color("AF_1"),
                 highlightColor: Color("AF_2"))
         case .hiking:
            return WorkoutTypeMetadata(
                icon: "Hiking",
                description: "Hiking",
                mainColor: Color("AG_1"),
                highlightColor: Color("AG_2"))
         case .running:
             return WorkoutTypeMetadata(
                 icon: "Running",
                 description: "Running",
                 mainColor: Color("AH_1"),
                 highlightColor: Color("AH_2"))
         case .mixedCardio:
             return WorkoutTypeMetadata(
                 icon: "MixedCardio",
                 description: "Mixed Cardio",
                 mainColor: Color("AI_1"),
                 highlightColor: Color("AI_2"))
         case .cycling:
             return WorkoutTypeMetadata(
                 icon: "Cycling",
                 description: "Cycling",
                 mainColor: Color("AJ_1"),
                 highlightColor: Color("AJ_2"))
         case .elliptical:
             return WorkoutTypeMetadata(
                 icon: "Elliptical",
                 description: "Elliptical",
                 mainColor: Color("AK_1"),
                 highlightColor: Color("AK_2"))
         case .stairs:
             return WorkoutTypeMetadata(
                 icon: "Stairs",
                 description: "Stairs",
                 mainColor: Color("AL_1"),
                 highlightColor: Color("AL_2"))
         case .stairClimbing:
             return WorkoutTypeMetadata(
                 icon: "Stairs",
                 description: "Stair Climbing",
                 mainColor: Color("AM_1"),
                 highlightColor: Color("AM_2"))
        case .stepTraining:
            return WorkoutTypeMetadata(
                icon: "Stairs",
                description: "Step Training",
                mainColor: Color("AN_1"),
                highlightColor: Color("AN_2"))
         case .handCycling:
             return WorkoutTypeMetadata(
                 icon: "Cycling",
                 description: "Hand Cycling",
                 mainColor: Color("AO_1"),
                 highlightColor: Color("AO_2"))

        // Wheelchair
        //
        case .wheelchairWalkPace:
            return WorkoutTypeMetadata(
                icon: "WheelchairWalkPace",
                description: "Wheelchair Walk Pace",
                mainColor: Color("BA_1"),
                highlightColor: Color("BA_2"))
        case .wheelchairRunPace:
            return WorkoutTypeMetadata(
                icon: "WheelchairRunPace",
                description: "Wheelchair Run Pace",
                mainColor: Color("BB_1"),
                highlightColor: Color("BB_2"))
        
        // Default
        //
        default:
            return WorkoutTypeMetadata(
                icon: "StrengthTraining",
                description: "Other",
                mainColor: Color("AO_1"),
                highlightColor: Color("AO_2"))
        }
    }

}
