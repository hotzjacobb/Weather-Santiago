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
//    let locationManager: CLLocationManager;
//    let vc: ViewController;
//    
//    // constructor
//    private override init() {
//        self.vc = 
//        self.locationManager = CLLocationManager()
//        super.init()
//    }
//    
//    static let shared = Location()
//    
//    
//    // Location permissions
//    func checkLocationPermissions() {
//        if (CLLocationManager.locationServicesEnabled()) {  // does the user have access to location services
//            locationManager.delegate = self  // this class gets location callback
//            switch CLLocationManager.authorizationStatus() {
//            case .notDetermined:
//                // Request when-in-use authorization initially
//                // This is the first and the ONLY time you will be able to ask the user for permission
//                locationManager.requestWhenInUseAuthorization()
//                break
//                
//            case .restricted, .denied:
//                // Disable location features
//                onLocationDisabled()
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
//        case .notDetermined:
//            //locationManager.delegate = self
//            locationManager.requestWhenInUseAuthorization()
//        case .authorizedWhenInUse:
//            locationManager.requestLocation()
//        case .denied, .restricted:
//            ViewController.onLocationDisabled()
//        default:
//            fatalError("Unexpected authorization value")
//        }
//    }
//    
//    
//    //Location successfully retrieved
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        weatherHandlerHelper(lat: locations[locations.count-1].coordinate.latitude, lon: locations[locations.count-1].coordinate.longitude)
//    }
//    
//    //Error when retrieving location
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        // Sends an alert to the user informint them of an error
//        let alert = UIAlertController(title: "Error in retrieving action", message: "There was an error in retrieving your location. You can try again by closing the application and reopening it", preferredStyle: UIAlertController.Style.alert)
//        // Button to dismiss the notice
//        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
//}
