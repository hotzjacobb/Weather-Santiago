//
//  WeatherInfo.swift
//  Weather Santiago
//
//  Created by Jacob Hotz on 2019-10-03.
//  Copyright © 2019 Jacob Hotz. All rights reserved.
//

import Foundation



struct WeatherDataTemp:Decodable {
    var weather: [WeatherData]
    var main: TempWrapperObj // the temperature in the user's unit of choice; if the user changes the temperature the app calculates the difference without another lookup
}



struct WeatherData:Decodable {
    var id: Int
    var main: String            // the weather's name
    var description: String     // longer description of weather
    var icon: String            // the appropriate photo URL for the given weather
}

struct FiveDayDataWrapper:Decodable {
    var list: [FiveDayData]
}

struct FiveDayData:Decodable {
    var weather: [WeatherData]
    var main: TempWrapperObj
    var dt_txt: String
}

struct TempWrapperObj:Decodable {
    var temp: Double
}

func averageFiveDayData(_ forecasts: [FiveDayData]) {      // Because I'm using the free version of the API I have to extrapolate 3-hour interval forecasts into days
    // Args: Every three hour forecast recieved from the JSON
    var day1, day2, day3, day4, day5 : [FiveDayData]
    // first get into appropriate groupings
    // start by getting the first day
    guard var dayStart: String.Index = forecasts[0].dt_txt.lastIndex(of: "-") else {     // last index is a way to hack Swift's non-intuitive methods for index of
        fatalError("JSON date format incorrect")
    }
    guard let dayEnd: String.Index = forecasts[0].dt_txt.firstIndex(of: " ") else {
        fatalError("JSON date format incorrect")
    }
    // Swift methods to add or subtract from a string index; adjusting to get the right substring
    // note that the API uses YY-MM-DD
    dayStart = forecasts[0].dt_txt.index(dayStart, offsetBy: 1)
    var firstDay = forecasts[0].dt_txt[dayStart..<dayEnd]
    for i in 0..<forecasts.count {
        while (firstDay == firstDay) {
            
        }
    }
}
