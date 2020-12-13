//
//  SourcePreference.swift
//  Workouts
//
//  Created by Emily Cheroske on 12/12/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import Foundation

public enum SourcePreference: String, CaseIterable, Setting {

    case okapiOnly
    case activitiesOnly
    case okapiAndActivities
    case allHealthkitWorkouts
    
    init() {

        let sourceValue = UserDefaults.standard.string(forKey: SettingsViewModel.SettingsKey.sourcePreference.rawValue)
        
        switch sourceValue {

        case SourcePreference.okapiOnly.rawValue:

            self = .okapiOnly

        case SourcePreference.activitiesOnly.rawValue:

            self = .activitiesOnly

        case SourcePreference.okapiAndActivities.rawValue:

            self = .okapiAndActivities

        case SourcePreference.allHealthkitWorkouts.rawValue:

            self = .allHealthkitWorkouts

        default:

            self = .okapiOnly

        }

    }

    public var stringValue: String {

        switch self {

        case .okapiOnly:

            return Strings.okapiOnly

        case .activitiesOnly:

            return Strings.activitiesOnly

        case .okapiAndActivities:

            return Strings.okapiAndActivities

        case .allHealthkitWorkouts:

            return Strings.allHealthKit

        }

    }
    
    public func save() {

        UserDefaults.standard.setValue(self.rawValue, forKey: SettingsViewModel.SettingsKey.sourcePreference.rawValue)

    }
    
}

extension SourcePreference {
    
    private struct Strings {

        public static var allHealthKit: String {
            NSLocalizedString("com.okapi.settingsView.allHealthKit", value: "All HealthKit Workouts", comment: "All health kit workouts text")
        }
        
        public static var okapiOnly: String {
            NSLocalizedString("com.okapi.settingsView.okapiOnly", value: "Okapi Only", comment: "Okapi only recorded workouts")
        }

        public static var activitiesOnly: String {
            NSLocalizedString("com.okapi.settingsView.activitiesOnly", value: "Activities Only", comment: "Activities only recorded workouts")
        }
        
        public static var okapiAndActivities: String {
            NSLocalizedString("com.okapi.settingsView.okapiAndActivities", value: "Okapi and Activities", comment: "Only workouts recorded by the activities app and okapi")
        }
    }
}
