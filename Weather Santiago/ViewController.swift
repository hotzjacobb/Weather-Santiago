//
//  ViewController.swift
//  Weather Santiago
//
//  Created by Jacob Hotz on 2019-09-25.
//  Copyright © 2019 Jacob Hotz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var toggleMode: UIButton!
    
    // Struct that encompasses data from both the daily and five-day forecast
    struct WeatherInfo {
        var currentDayData: CurrentData?
        var fiveDayData: FiveDayData?
    }
    
    // Fields
    var daily = true
    var unit = Unit.Celcius
    var weatherData: WeatherInfo?
    
    
    @IBAction func changeMode(_ sender: UIButton) {
        
        // Change title of button to be that of now not-in-use mode
        if (daily) {
            sender.setTitle("Daily", for: .normal)
            daily = false;
        } else {
            sender.setTitle("Weekly", for: .normal)
            daily = true
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        weatherData = WeatherInfo()
        let weatherData = WeatherRequest(unit)
        weatherData.getCurrentWeather { [weak self] result in         // tell Swift garbage collection if view dismissed -> free memory
            switch result {
            case .failure(let error):
                print("failure")
                print(error)
            case .success(let weatherCurrent):
                print("success")
                self?.weatherData?.currentDayData = weatherCurrent
                let debugTemp = self!.weatherData?.currentDayData?.main.temp
                print("The temp is \(debugTemp)")
                
            }
        }
        weatherData.getFiveDayWeather { [weak self] result in         // tell Swift garbage collection if view dismissed -> free memory
            switch result {
            case .failure(let error):
                print("failure")
                print(error)
            case .success(let weatherCurrent):
                print("success")
                self?.weatherData?.currentDayData = weatherCurrent
                let debugTemp = self!.weatherData?.currentDayData?.main.temp
                print("The temp is \(debugTemp)")
                
            }
        }
        
        
    }


}

