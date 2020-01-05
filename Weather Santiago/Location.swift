//
//  Location.swift
//  Weather Santiago
//
//  Created by Jacob Hotz on 2019-12-09.
//  Copyright © 2019 Jacob Hotz. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

extension UIApplication {
    
    static func topViewController(base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
}

class Location: NSObject, CLLocationManagerDelegate {

    // Singleton
    static let shared = Location();
    
    // Fields
    let locationManager: CLLocationManager = CLLocationManager()
    
    override private init() {super.init()}
    
    // Location permissions
    func checkLocationPermissions(vc: ViewController) {
        if (CLLocationManager.locationServicesEnabled()) {  // does the user have access to location services
            locationManager.delegate = self  // this class gets location callback
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                // Request when-in-use authorization initially
                // This is the first and the ONLY time you will be able to ask the user for permission
                locationManager.requestWhenInUseAuthorization()
                break
                
            case .restricted, .denied:
                // Disable location features and ask user to remedy
                vc.onLocationDisabled()
            case .authorizedWhenInUse, .authorizedAlways:
                // we can make the request as the user previously authorized location services
                locationManager.requestLocation()
                //weatherHandlerHelper()
                print("Full Access")
                break
                
            default:
                fatalError("Unexpected Switch case")
            }
        } else {
            // fail gracefully due to no location services
            // TODO
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        case .denied, .restricted:
            let vc = UIApplication.topViewController() as! ViewController   // get main view controller
            vc.onLocationDisabled()                                         // give alert
        default:
            fatalError("Unexpected authorization value")
        }
    }
    
    // Location successfully retrieved
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let vc = UIApplication.topViewController() as! ViewController
        let weatherData = vc.weatherData!;
        WeatherRequest.weatherHandlerHelper(lat: locations[locations.count-1].coordinate.latitude, lon: locations[locations.count-1].coordinate.longitude, weatherData: weatherData)
    }
    
    //Error when retrieving location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Sends an alert to the user informint them of an error
        let alert = UIAlertController(title: "Error in retrieving action", message: "There was an error in retrieving your location. You can try again by closing the application and reopening it", preferredStyle: UIAlertController.Style.alert)
        // Button to dismiss the notice
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        let vc = UIApplication.topViewController() as! ViewController
        vc.present(alert, animated: true, completion: nil)
    }

}
