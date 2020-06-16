//
//  UnitConversion.swift
//  Workouts
//
//  Created by Emily Cheroske on 5/23/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import Foundation

func metersToFeet(meters: Double) -> Double {
    return meters * 3.28084
}
func metersPerSecondToMinPerMile(pace: Double) -> Double {
    return (5280 / (pace * 196.82)) > 0 ? (5280 / (pace * 196.82)) : 0
}
