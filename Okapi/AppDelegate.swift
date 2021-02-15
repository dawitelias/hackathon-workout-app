//
//  AppDelegate.swift
//  Workouts
//
//  Created by Dawit Elias on 4/15/20.
//  Copyright © 2020 Dawit Elias. All rights reserved.
//

import UIKit
import ArcGIS

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Remove any image files older than 1 month
        //
        removeOldFiles()
        
        //license the app with the supplied License key
        do {
         let result = try AGSArcGISRuntimeEnvironment.setLicenseKey("runtimelite,1000,rud6315953372,none,GB2PMD17JYJ3R6EJM010")
            print("License Result : \(result.licenseStatus)")
        }
        catch let error as NSError {
         print("error: \(error)")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

