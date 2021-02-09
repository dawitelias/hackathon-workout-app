//
//  SettingsViewModel.swift
//  Workouts
//
//  Created by Emily Cheroske on 12/5/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI
import HealthKit

public protocol Setting {
    var stringValue: String { get }
    func save() -> Void
}

class UserSettings: ObservableObject {

    public enum SettingsKey: String {
        case unitPreference
        case colorTheme
    }

    @Published var userUnitPreferences = UnitPreference()

    @Published var themeColor = ThemeColor()

}
