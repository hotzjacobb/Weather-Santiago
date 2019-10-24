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
    var temp_min: Double
    var temp_max: Double
}

func averageFiveDayData(_ forecasts: [FiveDayData]) {      // Because I'm using the free version of the API I have to extrapolate 3-hour interval forecasts into days
    // Args: Every three hour forecast rec eved from the JSON
    //var day1 = [FiveDayData](), day2 = [FiveDayData](), day3 = [FiveDayData](), day4 = [FiveDayData](), day5 = [FiveDayData]()
    //var arrayOfDayArrays = [day1, day2, day3, day4, day5]        // note: Swift doesn't use pointers; it hard copies
    var arrayOfDayArrays = [[FiveDayData](), [FiveDayData](), [FiveDayData](), [FiveDayData](), [FiveDayData]()]
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
    // Start to perform condensing operation; We have to initialize a lot of variable to later compute avg. temp and high and low.
    var condensedFinalArray: [FiveDayData]        // array with five elements; one for each day
    var dayIndex = 0;                             // index in the final array of the entries we a currently processing; increment once we see new day
    var currentDay = forecasts[0].dt_txt[dayStart..<dayEnd]       // The Swift substring method
    var arrayElementDay: Substring
    var forecast = 0                       // the index of the forecast in the original array
    var numberOfEntriesDaily: Int = 0          // number of forecasts for the day; used to calc. avg. temp.
    var lowArrayDaily: [Double]
    var HighArrayDaily: [Double]
    while (forecast < forecasts.count) {  // check to see if the next entry is the same day as the previous entry or a new day
        arrayElementDay = forecasts[forecast].dt_txt[dayStart..<dayEnd]
        if (arrayElementDay == currentDay) {        // still on the same day; add to the dayx array and continue
            
        } else {                                    // new day; calculate old day and then add to dayx for this day
            var medianForecastIndex: Int = arrayOfDayArrays[dayIndex].count / 2                                   // (floor(array.count/2) is the index) forecast
            let medianForecast: WeatherData = arrayOfDayArrays[dayIndex][medianForecastIndex].weather[0]
            var calculatedWeatherData = WeatherData(id: medianForecast.id, main: medianForecast.main, description: medianForecast.description, icon: medianForecast.icon)      // note: to get the weather description we take the values from the "median"
            //var calculatedDay = WeatherDataTemp()
            condensedFinalArray.append(calculatedDay)
            dayIndex += 1
        }
        forecast += 1
    }
}
