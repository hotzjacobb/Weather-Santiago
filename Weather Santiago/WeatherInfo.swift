//
//  WeatherInfo.swift
//  Weather Santiago
//
//  Created by Jacob Hotz on 2019-10-03.
//  Copyright © 2019 Jacob Hotz. All rights reserved.
//

import Foundation

struct WeatherInfo:Decodable {
    var currentDayData: CurrentDayData
    var fiveDayData: FiveDayData!
}

struct CurrentDayData:Decodable {
    var weatherData: WeatherData
    var temp: Int
}

struct WeatherData:Decodable {
    var id: Int
    var main: String
    var descrip: String
    var icon: String
}

struct FiveDayData:Decodable {
    var weatherData: [WeatherData]
    var temp: [Int]
}

