//
//  WeatherInfo.swift
//  Weather Santiago
//
//  Created by Jeffrey Hotz on 2019-11-08.
//  Copyright © 2019 Jacob Hotz. All rights reserved.
//

import Foundation

// Class that encompasses data from both the daily and five-day forecast
class WeatherInfo {
    var currentDayData: WeatherDataTemp?
    var fiveDayData: [FiveDayData]?
    
    private init() {}
    public static var weatherData = WeatherInfo()
}
