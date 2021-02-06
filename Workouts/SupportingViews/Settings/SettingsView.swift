//
//  SettingsView.swift
//  Workouts
//
//  Created by Emily Cheroske on 12/5/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI

struct SettingsView: View {

    @EnvironmentObject var viewModel: UserSettings

    @Binding var showSettings: Bool

    var body: some View {

        NavigationView {

            Form {

                Image(Images.logo.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Section(header: Text(Strings.unitPreferences).font(.callout)) {

                    // Units picker
                    //
                    Picker(Strings.units, selection: $viewModel.userUnitPreferences) {

                        ForEach(UnitPreference.allCases, id: \.self) { item in

                            Text(item.stringValue).tag(UnitPreference.allCases.first(where: { $0.rawValue == item.rawValue }) ?? UnitPreference.usImperial)

                        }

                    }.pickerStyle(SegmentedPickerStyle())

                }

                Section(header: Text(Strings.appInfoText).font(.body)) {

                    NavigationLink(destination: AboutScreen()) {
                        Text(Strings.aboutLinkText)
                    }

                    NavigationLink(destination: Feedback()) {
                        Text(Strings.feedbackLinkText)
                    }

                    NavigationLink(destination: Licensing()) {
                        Text(Strings.acknowledgements)
                    }

                }

            }
            .onDisappear {

                viewModel.userUnitPreferences.save()

            }
            .modifier(GroupedListModifier())
            .navigationBarTitle(Strings.settings, displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {

                showSettings = false

            }) {

                Text(Strings.doneText).foregroundColor(Color.pink).bold()

            })

        }

    }

    // MARK: Style constants
    //
    private let unitsPickerWidth: CGFloat = 200

}

// MARK: Strings and assets
//
extension SettingsView {
    
    private enum Images: String {
        case logo
    }
    
    private struct Strings {

        public static var doneText: String {
            NSLocalizedString("com.okapi.settings.done", value: "Done", comment: "done text")
        }

        public static var allHealthkitWorkouts: String {
            NSLocalizedString("com.okapi.settings.allHealthKitWorkouts", value: "All HealthKit Workouts", comment: "Text for user to chose all workouts from health kit")
        }

        public static var onlyOkapiWorkouts: String {
            NSLocalizedString("com.okapi.settings.onlyOkapiWorkouts", value: "Okapi workouts only", comment: "Text for users to choose only workouts recorded from Okapi watch app")
        }

        public static var usStandard: String {
            NSLocalizedString("com.okapi.settings.usStandard", value: "US Standard", comment: "Unit type for us standard")
        }

        public static var metric: String {
            NSLocalizedString("com.okapi.settings.metric", value: "Metric", comment: "Unit type for metric")
        }

        public static var footerText: String {
            NSLocalizedString("com.okapi.settings.footerText", value: "Show workouts recorded from specific apps. We can only guarantee the data integrity from workouts recorded with the Okapi watch app.", comment: "Footer text expalaining that if you choose all health kit workouts, the data might not show up correctly")
        }

        public static var userPreferences: String {
            NSLocalizedString("com.okapi.settings.userPreferences", value: "User Preferences", comment: "User Preferences")
        }

        public static var source: String {
            NSLocalizedString("com.okapi.settings.appSource", value: "Source", comment: "User source preferences label")
        }

        public static var units: String {
            NSLocalizedString("com.okapi.settings.units", value: "Units", comment: "User unit preferences label")
        }
        
        public static var unitPreferences: String {
            NSLocalizedString("com.okapi.settings.unitPreferences", value: "Unit Preferences 📏", comment: "User unit preferences section header")
        }
        
        public static var sourcePreferences: String {
            NSLocalizedString("com.okapi.settings.sourcePreferences", value: "Source Preferences ⌚️", comment: "Source preferences section header")
        }

        public static var settings: String {
            NSLocalizedString("com.okapi.settings.settings", value: "Settings", comment: "Title of the settings page")
        }

        public static var appInfoText: String {
            NSLocalizedString("com.okapi.settings.appInfo", value: "App Info", comment: "App Info section header")
        }
        
        public static var aboutLinkText: String {
            NSLocalizedString("com.okapi.settings.aboutLink", value: "About", comment: "About link text")
        }
        
        public static var feedbackLinkText: String {
            NSLocalizedString("com.okapi.settings.feedbackLink", value: "Feedback", comment: "Feedback link text")
        }
        
        public static var acknowledgements: String {
            NSLocalizedString("com.okapi.settings.acknowledgements", value: "Acknowledgements", comment: "Acknowledgements link text.")
        }

    }

}

// MARK: Previews
//
struct SettingsView_Previews: PreviewProvider {

    static var previews: some View {

        SettingsView(showSettings: .constant(true))

    }

}
