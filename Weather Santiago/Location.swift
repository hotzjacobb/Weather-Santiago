//
//  Location.swift
//  Weather Santiago
//
//  Created by Jacob Hotz on 2019-12-09.
//  Copyright © 2019 Jacob Hotz. All rights reserved.
//

//import Foundation
//
//import CoreLocation
//
//class Location: NSObject, CLLocationManagerDelegate {
//    
//
//    
//    // constructor
//    private override init() {
//        super.init()
//        static let locationManager: CLLocationManager = CLLocationManager()
//    }
//    
//    
//    // Location permissions
//    func checkLocationPermissions() {
//        if (CLLocationManager.locationServicesEnabled()) {  // does the user have access to location services
//            switch CLLocationManager.authorizationStatus() {
//            case .notDetermined:
//                // Request when-in-use authorization initially
//                // This is the first and the ONLY time you will be able to ask the user for permission
//                locationManager.delegate = self
//                locationManager.requestWhenInUseAuthorization()
//                break
//                
//            case .restricted, .denied:
//                // Disable location features
//                let alert = UIAlertController(title: "Allow Location Access", message: "Weather Santiago needs access to your location. Turn on Location Services in your device settings.", preferredStyle: UIAlertController.Style.alert)
//                
//                // Button to Open Settings
//                alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { action in
//                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
//                        return
//                    }
//                    if UIApplication.shared.canOpenURL(settingsUrl) {
//                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//                            print("Settings opened: \(success)")
//                        })
//                    }
//                }))
//                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//                
//                break
//                
//            case .authorizedWhenInUse, .authorizedAlways:
//                // we can make the request as the user previously authorized location services
//                weatherHandlerHelper()
//                print("Full Access")
//                break
//                
//            default:
//                fatalError("Unexpected Switch case")
//            }
//        } else {
//            // fail gracefully due to no location services
//            // TODO
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .authorizedWhenInUse:
//            weatherHandlerHelper()
//        case .denied, .restricted:
//            onLocationDisabled()
//        default:
//            fatalError("Unexpected authorization value")
//        }
//    }
//    
//    // Location disabled helper
//    func onLocationDisabled() {
//        // Sends an alert to the user asking them to enable location services
//        let alert = UIAlertController(title: "Allow Location Access", message: "Weather Santiago needs access to your location. Turn on Location Services in your device settings.", preferredStyle: UIAlertController.Style.alert)
//        
//        // Button to Open Settings
//        alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { action in
//            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
//                return
//            }
//            if UIApplication.shared.canOpenURL(settingsUrl) {
//                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//                    print("Settings opened: \(success)")
//                })
//            }
//        }))
//    }
//    
//}
