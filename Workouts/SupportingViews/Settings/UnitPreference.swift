//
//  UnitPreference.swift
//  Workouts
//
//  Created by Emily Cheroske on 12/12/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import Foundation
import SwiftUI

public enum ThemeColor: String, CaseIterable, Setting {

    case A_1, B_1, C_1, D_1, E_1, F_1, G_1, H_1, I_1, J_1, K_1, L_1, M_1, N_1, O_1, P_1, Q_1, R_1, S_1, T_1, U_1, V_1, W_1, X_1, Y_1, Z_1, AA_1, AB_1, AC_1, AD_1, AE_1, AF_1, AG_1, AH_1, AI_1, AJ_1, AK_1, AL_1, AM_1, AN_1, AO_1, AP_1, AQ_1, AR_1, AS_1, AT_1, AU_1, AV_1, AW_1, AX_1, AY_1, AZ_1, BA_1, BB_1

    public var stringValue: String {

        rawValue

    }

    public func save() {

        UserDefaults.standard.setValue(rawValue, forKey: UserSettings.SettingsKey.colorTheme.rawValue)

    }

    public var color: Color {

        Color(rawValue)

    }

    init() {
        
        let themeColorValue = UserDefaults.standard.string(forKey: UserSettings.SettingsKey.colorTheme.rawValue)
        
        switch themeColorValue {
        case ThemeColor.A_1.rawValue:
            self = .A_1
        case ThemeColor.B_1.rawValue:
            self = .B_1
        case ThemeColor.C_1.rawValue:
            self = .C_1
        case ThemeColor.D_1.rawValue:
            self = .D_1
        case ThemeColor.E_1.rawValue:
            self = .E_1
        case ThemeColor.F_1.rawValue:
            self = .F_1
        case ThemeColor.G_1.rawValue:
            self = .G_1
        case ThemeColor.H_1.rawValue:
            self = .H_1
        case ThemeColor.I_1.rawValue:
            self = .I_1
        case ThemeColor.J_1.rawValue:
            self = .J_1
        case ThemeColor.K_1.rawValue:
            self = .K_1
        case ThemeColor.L_1.rawValue:
            self = .L_1
        case ThemeColor.M_1.rawValue:
            self = .M_1
        case ThemeColor.N_1.rawValue:
            self = .N_1
        case ThemeColor.O_1.rawValue:
            self = .O_1
        case ThemeColor.P_1.rawValue:
            self = .P_1
        case ThemeColor.Q_1.rawValue:
            self = .Q_1
        case ThemeColor.R_1.rawValue:
            self = .R_1
        case ThemeColor.S_1.rawValue:
            self = .S_1
        case ThemeColor.T_1.rawValue:
            self = .T_1
        case ThemeColor.U_1.rawValue:
            self = .U_1
        case ThemeColor.V_1.rawValue:
            self = .V_1
        case ThemeColor.W_1.rawValue:
            self = .W_1
        case ThemeColor.X_1.rawValue:
            self = .X_1
        case ThemeColor.Y_1.rawValue:
            self = .Y_1
        case ThemeColor.Z_1.rawValue:
            self = .Z_1
        case ThemeColor.AA_1.rawValue:
            self = .AA_1
        case ThemeColor.AB_1.rawValue:
            self = .AB_1
        case ThemeColor.AC_1.rawValue:
            self = .AC_1
        case ThemeColor.AD_1.rawValue:
            self = .AD_1
        case ThemeColor.AE_1.rawValue:
            self = .AE_1
        case ThemeColor.AF_1.rawValue:
            self = .AF_1
        case ThemeColor.AG_1.rawValue:
            self = .AG_1
        case ThemeColor.AH_1.rawValue:
            self = .AH_1
        case ThemeColor.AI_1.rawValue:
            self = .AI_1
        case ThemeColor.AJ_1.rawValue:
            self = .AJ_1
        case ThemeColor.AK_1.rawValue:
            self = .AK_1
        case ThemeColor.AL_1.rawValue:
            self = .AL_1
        case ThemeColor.AM_1.rawValue:
            self = .AM_1
        case ThemeColor.AN_1.rawValue:
            self = .AN_1
        case ThemeColor.AO_1.rawValue:
            self = .AO_1
        case ThemeColor.AP_1.rawValue:
            self = .AP_1
        case ThemeColor.AQ_1.rawValue:
            self = .AQ_1
        case ThemeColor.AR_1.rawValue:
            self = .AR_1
        case ThemeColor.AS_1.rawValue:
            self = .AS_1
        case ThemeColor.AT_1.rawValue:
            self = .AT_1
        case ThemeColor.AU_1.rawValue:
            self = .AU_1
        case ThemeColor.AV_1.rawValue:
            self = .AV_1
        case ThemeColor.AW_1.rawValue:
            self = .AW_1
        case ThemeColor.AX_1.rawValue:
            self = .AX_1
        case ThemeColor.AY_1.rawValue:
            self = .AY_1
        case ThemeColor.AZ_1.rawValue:
            self = .AZ_1
        case ThemeColor.BA_1.rawValue:
            self = .BA_1
        case ThemeColor.BB_1.rawValue:
            self = .BB_1
        default:
            self = .AA_1
        }
    }
    
    
}

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
