//
//  WeatherRequest.swift
//  Weather Santiago
//
//  Created by Jeffrey Hotz on 2019-10-06.
//  Copyright © 2019 Jacob Hotz. All rights reserved.
//

import Foundation

enum APIError:Error {
    case dataNotAvailable      // note: xcode complained when I tried to use generic error; potential fix
}

public enum Unit {
    case Celcius
    case Farenheit
}

struct WeatherRequest {
    let requestURL: URL
    let apiKey: String = "5ba466f91291902d0245b2d55d0522c1"
    let santiagoId = "3871336" // calls are made with the city id; list of cities available on API site openweathermap.org
    let unit: String


    init(_ unit: Unit) {
    if (unit == Unit.Celcius) {
        self.unit = "celcius"
        // TODO: convert temp
    } else {
        self.unit = "farenheit"
        // TODO: convert temp
    }
    let requestString: String = "https://samples.openweathermap.org/data/2.5/weather?id=\(santiagoId)&units=\(self.unit)&appid=\(apiKey)"
    guard let createUrl = URL(string: requestString) else {fatalError()}
    requestURL = createUrl
}
    
    
    // make async api request; two reqs. made one for current one for five-day
    func getWeather(completion: @escaping(Result<CurrentDayData, Error>) -> Void) {
        let fetchWeather = URLSession.shared.dataTask(with: requestURL) { (data, resp, err) in
            guard let jsonDataDaily = data else {completion(.failure(APIError.dataNotAvailable))
                return
            }
            do {
                let jsonResp = try JSONSerialization.jsonObject(with: jsonDataDaily, options: [])
                print(jsonResp)
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(CurrentDayData.self, from: jsonDataDaily)
                let weatherCurrent = weatherResponse
                completion(.success(weatherCurrent))
            } catch {
                print(error)
                completion(.failure(APIError.dataNotAvailable))
            }
            
    }
        fetchWeather.resume()
    }
    
}

