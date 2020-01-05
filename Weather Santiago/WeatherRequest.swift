//
//  WeatherRequest.swift
//  Weather Santiago
//
//  Created by Jacob Hotz on 2019-10-06.
//  Copyright © 2019 Jacob Hotz. All rights reserved.
//

import Foundation
import UIKit

public enum Unit {
    case Celcius
    case Farenheit
}

struct WeatherRequest {
    let requestURLCurrent: URL
    let requestURLFive: URL
    let apiKey: String = "5ba466f91291902d0245b2d55d0522c1"
//    let santiagoId = "3871336" // calls are made with the city id; list of cities available on API site openweathermap.org
    let lat: Double    // the user's latitude to make the call with
    let lon: Double    // the user's longitude to make the call with
    let unit: String


    init(_ unit: WeatherInfo.Temperature, _ lat: Double, _ lon: Double) {
        if (unit == WeatherInfo.Temperature.Celsius) {
        self.unit = "metric"
    } else {
        self.unit = "imperial"
    }
    self.lat = lat
    self.lon = lon
    // create string for current weather url lookup
    let requestStringCurrent: String = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=\(self.unit)&appid=\(apiKey)"
    guard let createUrlCurrent = URL(string: requestStringCurrent) else {fatalError()}
    requestURLCurrent = createUrlCurrent
    // create string for five-day weather url lookup
    let requestStringFive: String = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&units=\(self.unit)&appid=\(apiKey)"
    guard let createUrlFive = URL(string: requestStringFive) else {fatalError()}
    requestURLFive = createUrlFive
}
    
    // Calls the function to make API req. and handles the callback
    static func weatherHandlerHelper(lat: Double, lon: Double, weatherData: WeatherInfo) {
        let weatherReq = WeatherRequest(PreferencesManager.shared.currentTempUnit, lat, lon)
        weatherReq.getCurrentWeather { result in         // tell Swift garbage collection if view dismissed -> free memory
            switch result {
            case .failure(let error):
                print(error)
            case .success(let weatherCurrent):
                weatherData.currentDayData = weatherCurrent
                guard let currentDay = weatherData.currentDayData else {
                    fatalError()
                }
                print("%f", (currentDay.main.temp))
                let tempFormattedString = String(Int((currentDay.main.temp)))
                let currentWeatherText: String = (currentDay.weather[0].description)
                let weatherID = currentDay.weather[0].id
                DispatchQueue.main.async {                     // UI must be changed from main thread otherwise threads contradict each other
                    let vc = UIApplication.topViewController() as! ViewController   // get main view controller
                    vc.tempLabel.text = tempFormattedString  + "°"
                    vc.weatherLabel.text = currentWeatherText
                    vc.cityLabel.text = currentDay.name            // the city's name
                    vc.displayAppropriatePhoto(weatherID)           // called last as it loads all the images in
                }
            }
        }
        weatherReq.getFiveDayWeather { result in         // tell Swift garbage collection if view dismissed -> free memory
            let vc = UIApplication.topViewController() as! ViewController   // get main view controller
            switch result {
            case .failure(let error):
                print(error)
            case .success(let weatherFiveDay):
                DispatchQueue.main.async {                     // Allow to switch now that we have all the data
                    let vc = UIApplication.topViewController() as! ViewController   // get main view controller
                    vc.toggleMode.isEnabled = true
                    vc.toggleUnit.isEnabled = true
                }
                
                vc.weatherData?.fiveDayData = weatherFiveDay
            }
        }
        
    }

    
    
    // make async api request for current weather
    func getCurrentWeather(completion: @escaping(Result<WeatherDataTemp, Error>) -> Void) {
        let fetchWeatherCurrent = URLSession.shared.dataTask(with: requestURLCurrent) { (data, resp, err) in
            guard let jsonDataDaily = data else {completion(.failure(NSError(domain: "networkFailure", code: 404, userInfo: nil)))
                return
            }
            do {
                let jsonResp = try JSONSerialization.jsonObject(with: jsonDataDaily, options: [])
                print(jsonResp)
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(WeatherDataTemp.self, from: jsonDataDaily)
                let weatherCurrent = weatherResponse
                print(weatherResponse)
                completion(.success(weatherCurrent))
            } catch {
                print(error)
                completion(.failure(NSError(domain: "parsingFailure", code: 1, userInfo: nil)))
            }
            
    }
        fetchWeatherCurrent.resume()
    }
    
    // make async api request for array of three-hour forecasts over next five days
    func getFiveDayWeather(completion: @escaping(Result<[FiveDayData], Error>) -> Void) {
        let fetchWeatherFive = URLSession.shared.dataTask(with: requestURLFive) { (data, resp, err) in
            guard let jsonDataDaily = data else {completion(.failure(NSError(domain: "networkFailure", code: 404, userInfo: nil)))
                return
            }
            do {
//                let jsonResp = try JSONSerialization.jsonObject(with: jsonDataDaily, options: [])
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(FiveDayDataWrapper.self, from: jsonDataDaily)
                var weatherList = weatherResponse.list
                weatherList = averageFiveDayData(weatherList)
                completion(.success(weatherList))
            } catch {
                print(error)
                completion(.failure(NSError(domain: "parsingFailure", code: 1, userInfo: nil)))
            }
            
        }
        fetchWeatherFive.resume()
    }
    
}

