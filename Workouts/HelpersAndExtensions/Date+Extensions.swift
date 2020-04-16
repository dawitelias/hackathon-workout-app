//
//  Date+Extensions.swift
//  Workouts
//
//  Created by Emily Cheroske on 4/16/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import Foundation

extension Date {
    var weekday: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        return dateFormatter.string(from: self)
    }
}
