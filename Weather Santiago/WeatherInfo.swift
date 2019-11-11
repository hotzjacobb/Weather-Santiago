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
    
    enum Temperature: Int {
        case Celsius
        case Farenheit
    }
    
    
    private init() {}
    public static var weatherData = WeatherInfo()
    
    func celsiusToFarenheit(day: FiveDayData) -> FiveDayData {
        let high = day.main.temp_max * (9/5) + 32
        let avg = day.main.temp * (9/5) + 32
        let low = day.main.temp_min * (9/5) + 32
        let main = TempWrapperObj(temp: avg, temp_min: low, temp_max: high)
        let dayConverted = FiveDayData(weather: day.weather, main: main, dt_txt: day.dt_txt)
        return dayConverted
    }
    
    func farenheitToCelsius(day: FiveDayData) -> FiveDayData {
        let high = (day.main.temp_max - 32) * (5/9)
        let avg = (day.main.temp - 32) * (5/9)
        let low = (day.main.temp_min - 32) * (5/9)
        let main = TempWrapperObj(temp: avg, temp_min: low, temp_max: high)
        let dayConverted = FiveDayData(weather: day.weather, main: main, dt_txt: day.dt_txt)
        return dayConverted
    }

}
