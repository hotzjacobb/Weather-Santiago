//
//  UILabelCellObservable.swift
//  Weather Santiago
//
//  Created by Jeffrey Hotz on 2019-11-10.
//  Copyright © 2019 Jacob Hotz. All rights reserved.
//

import UIKit

class UILabelCellObservable: UILabel, Observer {

    static private var nextId = 0
    
    var id: Int
    
    enum LabelCategory {
        case high
        case avg
        case low
    }
    
    var category: LabelCategory?
    
    var index: Int?
    
    required init?(coder aDecoder: NSCoder) {
        self.id = UILabelCellObservable.nextId
        UILabelCellObservable.nextId += 1
        super.init(coder: aDecoder)
    }
    
    func update(_ weatherData: WeatherInfo) {
        switch self.category {
        case .high?:
            self.text = String(Int((weatherData.fiveDayData?[index!].main.temp_max)!))
        case .avg?:
            self.text = String(Int((weatherData.fiveDayData?[index!].main.temp)!))
        case .low?:
            self.text = String(Int((weatherData.fiveDayData?[index!].main.temp_min)!))
        case .none:
            fatalError("unexpected enum value")
        }
    }
}
