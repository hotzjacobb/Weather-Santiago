//
//  WeatherInfo.swift
//  Weather Santiago
//
//  Created by Jacob Hotz on 2019-10-03.
//  Copyright © 2019 Jacob Hotz. All rights reserved.
//

import Foundation



struct CurrentData:Decodable {
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
}

struct TempWrapperObj:Decodable {
    var temp: Double
}

func averageFiveDayData() {      // Because I'm using the free version of the API I have to manually average 3-hour interval forecasts
    // TODO
}
