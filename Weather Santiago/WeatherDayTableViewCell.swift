//
//  WeatherDayTableViewCell.swift
//  Weather Santiago
//
//  Created by Jeffrey Hotz on 2019-11-07.
//  Copyright © 2019 Jacob Hotz. All rights reserved.
//

import UIKit

class WeatherDayTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayOfTheWeek: UILabel!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    
    @IBOutlet weak var high: UILabelCellObservable!
    
    
    @IBOutlet weak var avg: UILabelCellObservable!
    
    
    @IBOutlet weak var low: UILabelCellObservable!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
