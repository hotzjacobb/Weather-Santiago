//
//  ViewController.swift
//  Weather Santiago
//
//  Created by Jacob Hotz on 2019-09-25.
//  Copyright © 2019 Jacob Hotz. All rights reserved.
//

import UIKit

// Struct that encompasses data from both the daily and five-day forecast
struct WeatherInfo {                        // TODO: change to class; singleton
    var currentDayData: WeatherDataTemp?
    var fiveDayData: [FiveDayData]?
}

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tempLabel: UILabelObserver!
    @IBOutlet weak var toggleMode: UIButton!
    
    @IBOutlet weak var toggleUnit: UISegmentedControlObservable!
    
    
    enum LoadingMessage: String {
        case Window = "looking out the window"
        case Gazing = "gazing up above"
        case Thermometer = "dusting off the thermometer"
    }
    @IBOutlet weak var weatherLabel: UILabel!
    
    
    // Fields
    var daily = true
    var unit = Unit.Celcius
    var weatherData: WeatherInfo?
    let formatter = NumberFormatter()
    

    
    @IBAction func changeMode(_ sender: UIButton) {       // sent by toggleMode
        
        // Change title of button to be that of now not-in-use mode
        if (daily) {
            sender.setTitle("Daily", for: .normal)
            daily = false;
        } else {
            sender.setTitle("Weekly", for: .normal)
            daily = true
        }
    }
  
    enum Temperature: Int {
        case Celsius
        case Farenheit
    }
    
    @IBAction func switchUnits(_ sender: UISegmentedControl) {
        guard let tempMode = Temperature(rawValue: toggleUnit.selectedSegmentIndex) else {
            fatalError("Unexpected toggleUnit.selectedSegmentIndex value")
        }
        switch (tempMode) {                  // switch to Farenheit
            
        case .Farenheit:
            
            self.weatherData!.currentDayData!.main.temp = self.weatherData!.currentDayData!.main.temp * (9/5) + 32
            
            for var element in self.weatherData!.fiveDayData! {      // convert all temps
                element.main.temp = element.main.temp * (9/5) + 32
                element.main.temp_min = element.main.temp_min * (9/5) + 32
                element.main.temp_max = element.main.temp_max * (9/5) + 32
            }
            
        case .Celsius:                                              // switch to Celcius
            self.weatherData!.currentDayData!.main.temp = (self.weatherData!.currentDayData!.main.temp - 32) * (5/9)
            for var element in self.weatherData!.fiveDayData! {      // convert all temps
                element.main.temp = (element.main.temp - 32) * (5/9)
                element.main.temp_min = (element.main.temp_min - 32) * (5/9)
                element.main.temp_max = (element.main.temp_max - 32) * (5/9)
            }
        }
        guard let weatherDataToSend: WeatherInfo = weatherData else {
            fatalError("Weather Data not instantiated")
        }
        toggleUnit.notifyObservers(toggleUnit.observers, weatherDataToSend, formatter)   // TODO: formatter probably passed as pointer use other strategy to keep in memory
    }
    
    
    @IBAction func switchMode(_ sender: UIButton) {
        
    }
    

    private func chooseLoadingMessage() {
        let loadNumber: Int = Int.random(in: 0..<3)    // equally weighted chance
        let loadMessage: String
        switch loadNumber {
        case 0:
            loadMessage = LoadingMessage.Window.rawValue
        case 1:
            loadMessage = LoadingMessage.Gazing.rawValue
        case 2:
            loadMessage = LoadingMessage.Thermometer.rawValue
        default:
            fatalError("Unexpected random value")
        }
        tempLabel.text = "loading..."
        weatherLabel.text = loadMessage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.chooseLoadingMessage()
        toggleUnit.addObserver(tempLabel)
        weatherData = WeatherInfo()
        let weatherData = WeatherRequest(unit)
        weatherData.getCurrentWeather { [weak self] result in         // tell Swift garbage collection if view dismissed -> free memory
            switch result {
            case .failure(let error):
                //print("failure")
                print(error)
            case .success(let weatherCurrent):
                print("success")
                //self?.weatherData?.currentDayData = WeatherDataTemp(weather: weatherCurrent.weather, main: weatherCurrent.main)
                self?.weatherData?.currentDayData = weatherCurrent
                let currentDay = self!.weatherData?.currentDayData!
                self?.formatter.numberStyle = NumberFormatter.Style.decimal
                self?.formatter.roundingMode = NumberFormatter.RoundingMode.halfUp
                self?.formatter.maximumFractionDigits = 1
                let tempFormattedString = self?.formatter.string(from: NSNumber(value: (currentDay?.main.temp)!))
                let currentWeatherText: String = (currentDay?.weather[0].description)!
                DispatchQueue.main.async {                     // UI must be changed from main thread otherwise threads contradict each other
                    self?.tempLabel.text = tempFormattedString!  + "°"
                    self?.weatherLabel.text = currentWeatherText
                    self?.toggleMode.isEnabled = true
                    self?.toggleUnit.isEnabled = true
                }
            }
        }
        weatherData.getFiveDayWeather { [weak self] result in         // tell Swift garbage collection if view dismissed -> free memory
            switch result {
            case .failure(let error):
                //print("failure")
                print(error)
            case .success(let weatherFiveDay):
                //print("success")
                self?.weatherData?.fiveDayData = weatherFiveDay
            }
        }
        
        
    }


}

