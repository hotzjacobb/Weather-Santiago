//
//  WeatherInfo.swift
//  Weather Santiago
//
//  Created by Jacob Hotz on 2019-10-03.
//  Copyright © 2019 Jacob Hotz. All rights reserved.
//

import Foundation



struct WeatherDataTemp:Decodable {
    var name: String            // the city's name
    var weather: [WeatherData]
    var main: TempWrapperObj    // the temperature in the user's unit of choice; if the user changes the temperature the app calculates the difference without another lookup
}



struct WeatherData:Decodable {
    var id: Int
    var main: String            // the weather's name
    var description: String     // longer description of weather
    var icon: String            // the appropriate photo URL for the given weather
}

struct FiveDayDataWrapper:Decodable {
    var list: [FiveDayData]
    var city: CityNameWrapper
}

struct CityNameWrapper:Decodable {
    var name: String
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



func averageFiveDayData(_ forecasts: [FiveDayData]) -> [FiveDayData] {      // Because I'm using the free version of the API I have to extrapolate 3-hour interval forecasts into days
    // Args: Every three hour forecast received from the JSON
    var arrayOfDayArrays = [[FiveDayData](), [FiveDayData](), [FiveDayData](), [FiveDayData](), [FiveDayData](), [FiveDayData]()]  // the last day is not used
    // first get into appropriate groupings
    // start by getting the first day
    guard var dayStart: String.Index = forecasts[0].dt_txt.lastIndex(of: "-") else {     // last index is a way to "hack" Swift's non-intuitive methods for index of
        fatalError("JSON date format incorrect")
    }
    guard let dayEnd: String.Index = forecasts[0].dt_txt.firstIndex(of: " ") else {
        fatalError("JSON date format incorrect")
    }
    // Swift methods to add or subtract from a string index; adjusting to get the right substring
    // note that the API uses YY-MM-DD
    dayStart = forecasts[0].dt_txt.index(dayStart, offsetBy: 1)
    // Start to perform condensing operation; We have to initialize a lot of variable to later compute avg. temp and high and low.
    var condensedFinalArray = [FiveDayData]()        // array with five elements; one for each day
    var dayIndex = 0;                             // index in the final array of the entries we a currently processing; increment once we see new day
    var currentDay = forecasts[0].dt_txt[dayStart..<dayEnd]       // The Swift substring method
    var arrayElementDay: Substring
    var forecast = 0                       // the index of the forecast in the original array
    while (forecast < forecasts.count) {  // check to see if the next entry is the same day as the previous entry or a new day
        arrayElementDay = forecasts[forecast].dt_txt[dayStart..<dayEnd]
        if (arrayElementDay == currentDay && forecast != forecasts.count - 1) {        // still on the same day; add to the dayx array and continue
            arrayOfDayArrays[dayIndex].append(forecasts[forecast])  // add to that day's array; processing happens once we move past
        } else {
            // new day; calculate old day in addition to adding new day
            currentDay = arrayElementDay                            // update to new day for next comparisons
            if (forecast != forecasts.count - 1) {                  // normal case
            dayIndex += 1
            arrayOfDayArrays[dayIndex-1].append(forecasts[forecast])
            condensedFinalArray.append(averagedDay(arrayOfDayArrays[dayIndex-1]))
            } else {                                                  // for the last forecast we must calculate the day as well
            arrayOfDayArrays[dayIndex].append(forecasts[forecast])
            condensedFinalArray.append(averagedDay(arrayOfDayArrays[dayIndex]))
            }
        }
        forecast += 1
    }
    return condensedFinalArray
}

// this function takes an array of forescasts all from the same day and returns one FiveDayData object to be appended to final array by caller
private func averagedDay(_ dayArray: [FiveDayData]) -> FiveDayData {
    let medianForecastIndex: Int = dayArray.count / 2                                   // (floor(array.count/2) is the index) forecast
    let medianForecast: WeatherData = dayArray[medianForecastIndex].weather[0]
    var highTemp: Double = dayArray[0].main.temp_max
    var lowTemp: Double = dayArray[0].main.temp_min
    var avgTemp: Double = 0
    for element in dayArray {
        if (element.main.temp_min < lowTemp) {
            lowTemp = element.main.temp_min
        }
        if (element.main.temp_max > highTemp) {
            highTemp = element.main.temp_max
        }
        avgTemp += element.main.temp
    }
    avgTemp = avgTemp / Double(dayArray.count)   // now the average of the temperatures
    /*let calculatedDay = FiveDayData(weather: [WeatherData(id: medianForecast.id, main: medianForecast.main, description: medianForecast.description, icon: medianForecast.icon)], main: TempWrapperObj(temp: avgTemp, temp_min: lowTemp, temp_max: highTemp), dt_txt: arrayOfDayArrays[dayIndex][0].dt_txt)    // note: to get the weather description we take the values from the "median" */
    return FiveDayData(weather: [WeatherData(id: medianForecast.id, main: medianForecast.main, description: medianForecast.description, icon: medianForecast.icon)], main: TempWrapperObj(temp: avgTemp, temp_min: lowTemp, temp_max: highTemp), dt_txt: dayArray[0].dt_txt)  // note: to get the weather description we take the values from the "median"
}
