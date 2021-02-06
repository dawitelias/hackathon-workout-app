//
//  UnitPreference.swift
//  Workouts
//
//  Created by Emily Cheroske on 12/12/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import Foundation

public enum UnitPreference: String, CaseIterable, Setting {

    case usImperial
    case metric

    init() {

        let unitValue = UserDefaults.standard.string(forKey: UserSettings.SettingsKey.unitPreference.rawValue)
        
        switch unitValue {

        case UnitPreference.usImperial.rawValue:

            self = .usImperial

        case UnitPreference.metric.rawValue:

            self = .metric

        default:
        
            self = .usImperial

        }

    }

    // Conformance to the Setting protocol
    //
    public var stringValue: String {
        
        switch self {

        case .metric:

            return Strings.metric

        case .usImperial:

            return Strings.imperial

        }

    }
    
    public func save() {

        UserDefaults.standard.setValue(self.rawValue, forKey: UserSettings.SettingsKey.unitPreference.rawValue)

    }

}

extension UnitPreference {

    var abbreviatedDistanceUnit: String {
        
        switch self {
        case .metric:
            return "km"
        case .usImperial:
            return "mi"
        }

    }
    
    var distanceUnit: String {
        
        switch self {
        case .metric:
            return "kilometers"
        case .usImperial:
            return "miles"
        }

    }
    
    var elevartionUnit: String {
        
        switch self {
        case .metric:
            return "meters"
        default:
            return "feet"
        }

    }
    
    var abbreviatedElevationUnit: String {

        switch self {
        case .metric:
            return "m"
        default:
            return "ft"
        }

    }
    
    var speed: String {
        
        switch self {
        case .metric:
            return "km/h"
        default:
            return "mph"
        }

    }

}

extension UnitPreference {

    private struct Strings {
        public static var metric: String {
            NSLocalizedString("com.okapi.settingsView.metric", value: "Metric", comment: "text for metric units")
        }
        public static var imperial: String {
            NSLocalizedString("com.okapi.settingsView.imperial", value: "Imperial", comment: "text for imperial units")
        }
    }

}
