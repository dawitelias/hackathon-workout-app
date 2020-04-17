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

extension TimeInterval {
    func getTimerStyleActivityDurationString() -> String {
        var activityDurationString = "00:00:00"

        let integerSelf = Int(self)

        let hours = integerSelf/3600
        let minutes = Int((integerSelf - (hours * 3600))/60)
        let seconds = integerSelf % 60

        activityDurationString = String(format: "%02d:%02d:%02d", arguments: [hours, minutes, seconds])
        
        return activityDurationString
    }
    func getHoursString() -> String {
        let hoursValue = self/3600
        return "\(String.init(format: "%.2f", hoursValue)) hr"
    }
    func getHoursAndMinutesString() -> String {
        let hoursValue = Int(self/3600)
        let minutesValue = Int(self/60) % 60

        if hoursValue != 0 {
            return "\(hoursValue) hr \(minutesValue) min"
        } else {
            return "\(minutesValue) min"
        }
    }
}
