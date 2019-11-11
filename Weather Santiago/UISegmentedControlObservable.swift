//
//  UISegmentedControlObservable.swift
//  Weather Santiago
//
//  Created by Jeffrey Hotz on 2019-10-28.
//  Copyright © 2019 Jacob Hotz. All rights reserved.
//

import UIKit

class UISegmentedControlObservable: UISegmentedControl, Observable {
    
    var observers: [Observer] = [] // array of GUI labels that must be updated after change
    
    func addObserver(_ observer: Observer) {
        observers.append(observer)
    }
    
    func notifyObservers(_ observers: [Observer],_ weatherData: WeatherInfo) {
        observers.forEach({ $0.update(weatherData)})
    }
    

}
