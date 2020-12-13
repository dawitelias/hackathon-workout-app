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

        let unitValue = UserDefaults.standard.string(forKey: SettingsViewModel.SettingsKey.unitPreference.rawValue)
        
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

        UserDefaults.standard.setValue(self.rawValue, forKey: SettingsViewModel.SettingsKey.unitPreference.rawValue)

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
