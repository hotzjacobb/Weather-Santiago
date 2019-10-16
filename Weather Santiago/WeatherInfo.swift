//
//  WeatherInfo.swift
//  Weather Santiago
//
//  Created by Jacob Hotz on 2019-10-03.
//  Copyright © 2019 Jacob Hotz. All rights reserved.
//

import Foundation

// Struct that encompasses data from both the daily and five-day forecast
struct WeatherInfo:Decodable {
    var currentDayData: CurrentDayData
    var fiveDayData: FiveDayData!
}


struct CurrentDayData:Decodable {
    var weather: [WeatherData]
    var main: TempWrapperObj // the temperature in the user's unit of choice; if the user changes the temperature the app calculates the difference without another lookup.
}



struct WeatherData:Decodable {
    var id: Int
    var main: String            // the weather's name
    var description: String     // longer description of weather
    var icon: String            // the appropriate photo for the given weather
}

struct FiveDayData:Decodable {
    var weatherData: [WeatherData]
    var temp: [Int]
}

struct TempWrapperObj:Decodable {
    var temp: Int
}
