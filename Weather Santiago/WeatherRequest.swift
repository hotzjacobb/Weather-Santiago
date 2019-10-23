//
//  WeatherRequest.swift
//  Weather Santiago
//
//  Created by Jacob Hotz on 2019-10-06.
//  Copyright © 2019 Jacob Hotz. All rights reserved.
//

import Foundation

//enum APIError:Error {
//    case dataNotAvailable      // note: xcode complained when I tried to use generic error a la Java; potentially could remove
//}

public enum Unit {
    case Celcius
    case Farenheit
}

struct WeatherRequest {
    let requestURLCurrent: URL
    let requestURLFive: URL
    let apiKey: String = "5ba466f91291902d0245b2d55d0522c1"
    let santiagoId = "3871336" // calls are made with the city id; list of cities available on API site openweathermap.org
    let unit: String


    init(_ unit: Unit) {
    if (unit == Unit.Celcius) {
        self.unit = "metric"
        // TODO: convert temp
    } else {
        self.unit = "imperial"
        // TODO: convert temp
    }
    // create string for current weather url lookup
    let requestStringCurrent: String = "https://api.openweathermap.org/data/2.5/weather?id=\(santiagoId)&units=\(self.unit)&appid=\(apiKey)"
    guard let createUrlCurrent = URL(string: requestStringCurrent) else {fatalError()}
    requestURLCurrent = createUrlCurrent
    // create string for five-day weather url lookup
    let requestStringFive: String = "https://api.openweathermap.org/data/2.5/forecast?id=\(santiagoId)&units=\(self.unit)&appid=\(apiKey)"
    guard let createUrlFive = URL(string: requestStringFive) else {fatalError()}
    requestURLFive = createUrlFive
}
    
    
    // make async api request for current weather
    func getCurrentWeather(completion: @escaping(Result<WeatherDataTemp, Error>) -> Void) {
        let fetchWeatherCurrent = URLSession.shared.dataTask(with: requestURLCurrent) { (data, resp, err) in
            guard let jsonDataDaily = data else {completion(.failure(NSError(domain: "networkFailure", code: 404, userInfo: nil)))
                return
            }
            do {
                //let jsonResp = try JSONSerialization.jsonObject(with: jsonDataDaily, options: [])
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(WeatherDataTemp.self, from: jsonDataDaily)
                let weatherCurrent = weatherResponse
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
                let jsonResp = try JSONSerialization.jsonObject(with: jsonDataDaily, options: [])
                //print(jsonResp)
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(FiveDayDataWrapper.self, from: jsonDataDaily)
                let weatherList = weatherResponse.list
                averageFiveDayData(weatherList)
                completion(.success(weatherList))
            } catch {
                print(error)
                completion(.failure(NSError(domain: "parsingFailure", code: 1, userInfo: nil)))
            }
            
        }
        fetchWeatherFive.resume()
    }
    
}

