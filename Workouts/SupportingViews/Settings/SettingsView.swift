//
//  SettingsView.swift
//  Workouts
//
//  Created by Emily Cheroske on 12/5/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import SwiftUI
import HealthKit

struct SettingsView: View {

    @EnvironmentObject var viewModel: WorkoutData

    var body: some View {

        NavigationView {

            List {

                VStack(alignment: .center) {

                    Image(Images.logo.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(viewModel.settings.themeColor.color)
                        .frame(height: 200)

                    Text(Strings.appDescription)
                        .font(.callout)

                }

                Section(header: Text(Strings.unitPreferences).font(.callout)) {

                    // Units picker
                    //
                    Picker(Strings.units, selection: $viewModel.settings.userUnitPreferences) {

                        ForEach(UnitPreference.allCases, id: \.self) { item in

                            Text(item.stringValue).tag(UnitPreference.allCases.first(where: { $0.rawValue == item.rawValue }) ?? UnitPreference.usImperial)

                        }

                    }.pickerStyle(SegmentedPickerStyle())

                }

                Section(header: Text(Strings.chooseATheme).font(.callout)) {

                    ScrollView(.horizontal) {

                        HStack {

                            ForEach(ThemeColor.allCases, id: \.self) { color in

                                Rectangle()
                                    .foregroundColor(color.color)
                                    .frame(width: colorSwatchSize, height: colorSwatchSize)
                                    .border(color == viewModel.settings.themeColor ? Color.blue : Color.clear, width: 3)
                                    .onTapGesture {
                                        viewModel.settings.themeColor = color
                                        viewModel.objectWillChange.send()
                                    }

                            }

                        }

                    }

                }

                Section(header: Text(Strings.appInfoText).font(.body)) {

                    NavigationLink(destination: Feedback()) {
                        Text(Strings.feedbackLinkText)
                    }

                    NavigationLink(destination: Licensing()) {
                        Text(Strings.acknowledgements)
                    }

                }
    
                AppDevs()

            }
            .onDisappear {

                viewModel.settings.userUnitPreferences.save()
                viewModel.settings.themeColor.save()

            }
            .modifier(GroupedListModifier())
            .navigationBarTitle(Strings.settings, displayMode: .inline)

        }

    }

    // MARK: Style constants
    //
    private let unitsPickerWidth: CGFloat = 200
    private let colorSwatchSize: CGFloat = 40

}

// MARK: Strings and assets
//
extension SettingsView {

    private enum Images: String {

        case logo

    }

    private struct Strings {

        public static var appDescription: String {
            NSLocalizedString("com.okapi.settings.appDescription", value: "Okapi is a Fitness companion app. Only workouts recorded from the Fitness app will appear in Okapi.", comment: "Okapi app description text.")
        }

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
        
        public static var chooseATheme: String {
            NSLocalizedString("com.okapi.settings.chooseATheme", value: "Choose a theme 🎨", comment: "User theme preferences")
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
