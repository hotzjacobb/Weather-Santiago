//
//  ViewControllerWeekly.swift
//  Weather Santiago
//
//  Created by Jeffrey Hotz on 2019-10-28.
//  Copyright © 2019 Jacob Hotz. All rights reserved.
//

import UIKit

class ViewControllerWeekly: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var toggleUnit: UISegmentedControlObservable!
    
    var daysOfTheWeek = [String]()     // to be displayed on labels
    
    var weatherData: WeatherInfo?
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = self.tableView.dequeueReusableCell(withIdentifier: "Daily Forecast") as! WeatherDayTableViewCell
        newCell.dayOfTheWeek.text = daysOfTheWeek[indexPath.row]        // set the week day
        
        newCell.high.text = String(Int(((WeatherInfo.weatherData.fiveDayData?[indexPath.row].main.temp_max)!)))   // set the high
        newCell.high.category = .high   // give necessary info to fetch temp var on switch unit event
        newCell.high.index = indexPath.row
        
        newCell.low.text = String(Int(((WeatherInfo.weatherData.fiveDayData?[indexPath.row].main.temp_min)!)))   // set the low
        newCell.low.category = .low    // give necessary info to fetch temp var on switch unit event
        newCell.low.index = indexPath.row
        
        newCell.avg.text = String(Int(((WeatherInfo.weatherData.fiveDayData?[indexPath.row].main.temp)!)))    // set the average
        newCell.avg.category = .avg   // give necessary info to fetch temp var on switch unit event
        newCell.avg.index = indexPath.row
        
        newCell.weatherIcon.image = displayAppropriateIcon(((WeatherInfo.weatherData.fiveDayData?[indexPath.row].weather[0].id)!))
        return newCell
    }
    

    override func viewDidLayoutSubviews() {
        tableView.frame.size = tableView.contentSize   // make table row
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weatherData = WeatherInfo.weatherData
        
//        for cell in cells {
//            toggleUnit.addObserver(cell.high)
//            toggleUnit.addObserver(cell.avg)
//            toggleUnit.addObserver(cell.low)
//        }
        populateDayOfTheWeekArray()               // get the days of the weev for label
        // Do any additional setup after loading the view.
    }
    

    // adds temp labels to listen for change of
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let cells = self.tableView.visibleCells as! Array<WeatherDayTableViewCell>
                for cell in cells {
                    toggleUnit.addObserver(cell.high)
                    toggleUnit.addObserver(cell.avg)
                    toggleUnit.addObserver(cell.low)
                }
        toggleUnit.isEnabled = true
    }

    func populateDayOfTheWeekArray() {                         // get the first day of the week
        //return Calendar.current.component(.weekday, from: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        var date = Date()
        getAndAddDay(date, dateFormatter)
        date += 86400                 // time-interval in seconds added; 86400 seconds == one day
        getAndAddDay(date, dateFormatter)
        date += 86400
        getAndAddDay(date, dateFormatter)
        date += 86400
        getAndAddDay(date, dateFormatter)
        date += 86400
        getAndAddDay(date, dateFormatter)
    }
    
    // gets day of the week as a string and adds it to the array
    private func getAndAddDay(_ date: Date, _ dateFormatter: DateFormatter) {
        let weekDay = dateFormatter.string(from: date)
        self.daysOfTheWeek.append(weekDay)
    }
    
    // given the weatherID from the JSON; picks, loads, and displays the proper photo
    private func displayAppropriateIcon(_ weatherID: Int) -> UIImage {
        let bundle = Bundle(for: type(of: self))    // we'll load images in
        let clearDayImg = UIImage(named: "01d", in: bundle, compatibleWith: self.traitCollection)
        let fewCloudDayImg = UIImage(named: "02d", in: bundle, compatibleWith: self.traitCollection)
        let scatteredCloudImg = UIImage(named: "03d", in: bundle, compatibleWith: self.traitCollection)
        let brokenCloudImg = UIImage(named: "04d", in: bundle, compatibleWith: self.traitCollection)
        let drizzleRainImg = UIImage(named: "09d", in: bundle, compatibleWith: self.traitCollection)
        let rainDayImg = UIImage(named: "10d", in: bundle, compatibleWith: self.traitCollection)
        let thunderstormImg = UIImage(named: "11d", in: bundle, compatibleWith: self.traitCollection)
        let snowImg = UIImage(named: "13d", in: bundle, compatibleWith: self.traitCollection)
        let mistImg = UIImage(named: "50d", in: bundle, compatibleWith: self.traitCollection)
        let weatherLeadingDigit = weatherID / 100            // as defined by the api weatherID is a three digit number;
        switch weatherLeadingDigit {
        case 2 :
            return thunderstormImg!
        case 3 :
            return drizzleRainImg!
        case 5 :
            return rainDayImg!
        case 6 :
            return snowImg!
        case 7 :
            return mistImg!
        case 8 :
            if (weatherID == 800) {     // clear skies
                return clearDayImg!
            } else if (weatherID == 801) { // light clouds
                return fewCloudDayImg!
            } else if (weatherID == 802) { // medium clouds
                return scatteredCloudImg!
            } else {                // heavy clouds
                return brokenCloudImg!
            }
        default:
            fatalError("Unexpected weather ID")
        }
    }
    
    @IBAction func unwindToCurrentForecast(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func switchMode(_ sender: Any) {
        print("hey")
        guard let tempMode = WeatherInfo.Temperature(rawValue: toggleUnit.selectedSegmentIndex) else {
            fatalError("Unexpected toggleUnit.selectedSegmentIndex value")
        }
        PreferencesManager.shared.currentTempUnit = tempMode
        switch (tempMode) {                  // switch to Farenheit
            
        case .Farenheit:
            
            self.weatherData!.currentDayData!.main.temp = self.weatherData!.currentDayData!.main.temp * (9/5) + 32
            
            for var element in self.weatherData!.fiveDayData! {      // convert all temps
                print("cool")
                element.main.temp = element.main.temp * (9/5) + 32
                element.main.temp_min = element.main.temp_min * (9/5) + 32
                element.main.temp_max = element.main.temp_max * (9/5) + 32
            }
            
        case .Celsius:                                              // switch to Celcius
            self.weatherData!.currentDayData!.main.temp = (self.weatherData!.currentDayData!.main.temp - 32) * (5/9)
            for var element in self.weatherData!.fiveDayData! {      // convert all temps
                print("woah")
                element.main.temp = (element.main.temp - 32) * (5/9)
                element.main.temp_min = (element.main.temp_min - 32) * (5/9)
                element.main.temp_max = (element.main.temp_max - 32) * (5/9)
            }
        }
        guard let weatherDataToSend: WeatherInfo = weatherData else {
            fatalError("Weather Data not instantiated")
        }
        print(self.weatherData!.currentDayData!.main.temp)
        toggleUnit.notifyObservers(toggleUnit.observers, weatherDataToSend)
    }
    
}
