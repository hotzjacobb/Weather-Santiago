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
    

    
    // Fields
    var daily = true
    var unit = Unit.Celcius
    var currentWeather: CurrentDayData?
    
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
        let weatherData = WeatherRequest(unit)
        weatherData.getWeather { [weak self] result in
            switch result {
            case .failure(let error):
                print("failure")
                print(error)
            case .success(let weatherCurrent):
                print("success")
                self?.currentWeather = weatherCurrent
                let debugTemp = self!.currentWeather!.main.temp
                print("The temp is \(debugTemp)")
            }
            
        }
        
        
    }


}

