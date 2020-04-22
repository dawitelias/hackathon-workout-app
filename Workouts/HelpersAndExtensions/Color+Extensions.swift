//
//  Color.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/21/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

let flatColors = [
    Color("2000_leagues_under_the_sea"),
    Color("blue_martina"),
    Color("forgotten_purple"),
    Color("great_barrier_reef"),
    Color("ill_be_your_huckleberry"),
    Color("lavendar_rose"),
    Color("lavender_tea"),
    Color("meditaranean_sea"),
    Color("merchant_marine"),
    Color("no_idea"),
    Color("pixelated_grass"),
    Color("puffins_bill"),
    Color("sunflower"),
    Color("tasty_wine"),
    Color("tumeric_tonic"),
    Color("turkish_aqua"),
    Color("very_berry")
]

let appAccentColor = Color.pink

extension Color {
    
    static func getFlatUIColor() -> Color {
        let randomIndex = Int.random(in: 0...flatColors.count - 1)
        return flatColors[randomIndex]
    }
}
