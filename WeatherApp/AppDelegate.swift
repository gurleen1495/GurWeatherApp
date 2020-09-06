//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Gurleen Osahan on 06/09/20.
//  Copyright © 2020 Gurleen Osahan. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

     let GOOGLE_MAP_KEY = ""
        var locationManager: CLLocationManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         GMSServices.provideAPIKey(GOOGLE_MAP_KEY)
        self.checkUsersLocationServicesAuthorization()
        return true
    }

    
    func checkUsersLocationServicesAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            self.locationManager = CLLocationManager()
          locationManager?.requestWhenInUseAuthorization()
          self.locationManager?.requestAlwaysAuthorization()
            break
            
        case .restricted, .denied:
  
            break
            
        case .authorizedWhenInUse:
        
            break
            
        case .authorizedAlways:
  
            break
            
            
        @unknown default:
            break
        }
        
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

