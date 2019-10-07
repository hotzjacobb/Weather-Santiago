//
//  WeatherRequest.swift
//  Weather Santiago
//
//  Created by Jeffrey Hotz on 2019-10-06.
//  Copyright © 2019 Jacob Hotz. All rights reserved.
//

import Foundation

enum Unit: Int {
    case celcius
    case farenheit
}

struct WeatherRequest {
    let requestURL: URL
    let apiKey: String = "5ba466f91291902d0245b2d55d0522c1"
    let santiagoId = "3871336"
    let unit: String


init(unit: Unit) {
    if (unit == Unit.celcius) {
        self.unit = "celcius"
    } else {
        self.unit = "farenheit"
    }
    let requestString: String = "https://samples.openweathermap.org/data/2.5/weather?id=\(santiagoId)&units=\(self.unit)&appid=\(apiKey)"
    guard let createUrl = URL(string: requestString) else {fatalError()}
    requestURL = createUrl
}
    
    func getWeather(completion: @escaping(Result<WeatherRequest, Error>) -> Void) {
        let fetchData = URLSession.shared.dataTask(with: requestURL){data, _, _ in
            guard let jsonData = data else {completion(.failure())}
            
        }
    }

}
