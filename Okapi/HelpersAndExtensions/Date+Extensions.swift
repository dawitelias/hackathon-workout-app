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

    var day: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }

    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        return dateFormatter.string(from: self)
    }

    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }

    var hourAndMin: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: self)
    }

    func hoursBeforeNow(hr:TimeInterval) -> Date {
        return self.addingTimeInterval(-3600 * hr)
    }

    var weekAbbreviated: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        return dateFormatter.string(from: self)
    }

}

extension TimeInterval {

    func getTimerStyleActivityDurationString() -> String {

        let integerSelf = Int(self)

        let hours = integerSelf/3600
        let minutes = Int((integerSelf - (hours * 3600))/60)
        let seconds = integerSelf % 60
        
        return String(format: "%02d:%02d:%02d", arguments: [hours, minutes, seconds])
    }

    func getHoursString() -> String {
        "\(String.init(format: "%.2f", self/3600)) hr"
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
