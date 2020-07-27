//
//  HeartRateReading.swift
//  Workouts
//
//  Created by Emily Cheroske on 7/26/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import Foundation

class HeartRateReading {
    let reading: Int
    let date: Date
    
    init(_ reading: Int, _ dateTaken: Date) {
        self.reading = reading
        self.date = dateTaken
    }
}
