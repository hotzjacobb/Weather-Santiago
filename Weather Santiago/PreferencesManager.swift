//
//  PreferencesManager.swift
//  Weather Santiago
//
//  Created by Jacob Hotz on 2019-11-08.
//  Copyright © 2019 Jacob Hotz. All rights reserved.
//

import Foundation

class PreferencesManager {
    
    private init() {}
    static let shared = PreferencesManager()
    
    let userDefaults = UserDefaults.standard
    
    var currentTempUnit: WeatherInfo.Temperature {
        get {
            return WeatherInfo.Temperature(rawValue: userDefaults.integer(forKey: "tempUnit")) ?? .Celsius
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: "tempUnit")
        }
    }
    
    var cachedTemp: Double {
        get {
            return userDefaults.double(forKey: "temp")    // returns 0 if value does not exist
        }
        set {
            userDefaults.set(newValue, forKey: "temp")
        }
    }
    
    var cachedWeather: Int {
        get {
            return userDefaults.integer(forKey: "weatherID") // returns 0 if value does not exist
        }
        set {
            userDefaults.set(newValue, forKey: "weatherID")
        }
    }
    
    
  
}
