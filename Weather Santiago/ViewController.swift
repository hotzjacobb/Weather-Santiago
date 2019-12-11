//
//  ViewController.swift
//  Weather Santiago
//
//  Created by Jacob Hotz on 2019-09-25.
//  Copyright © 2019 Jacob Hotz. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager: CLLocationManager = CLLocationManager()
    
    
    @IBOutlet weak var tempLabel: UILabelObserver!
    @IBOutlet weak var toggleMode: UIButton!
    
  
    @IBOutlet weak var toggleUnit: UISegmentedControlObservable!
    
    
    @IBOutlet weak var weatherImageBackground: UIImageView!
    
    
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
    

    
  
    @IBAction func switchUnits(_ sender: UISegmentedControl) {
        guard let tempMode = WeatherInfo.Temperature(rawValue: toggleUnit.selectedSegmentIndex) else {
            fatalError("Unexpected toggleUnit.selectedSegmentIndex value")
        }
        PreferencesManager.shared.currentTempUnit = tempMode
        switch (tempMode) {
            
        case .Farenheit:                                            // switch to Farenheit
            self.weatherData!.currentDayData!.main.temp =                        self.weatherData!.currentDayData!.main.temp * (9/5) + 32
            
           self.weatherData!.fiveDayData = self.weatherData!.fiveDayData!.map(weatherData!.celsiusToFarenheit)
            
        case .Celsius:                                              // switch to Celcius
            self.weatherData!.currentDayData!.main.temp = (self.weatherData!.currentDayData!.main.temp - 32) * (5/9)
            
     self.weatherData!.fiveDayData = self.weatherData!.fiveDayData!.map(weatherData!.farenheitToCelsius)
            
            
        }
        guard let weatherDataToSend: WeatherInfo = weatherData else {
            fatalError("Weather Data not instantiated")
        }
        print(self.weatherData!.currentDayData!.main.temp)
        toggleUnit.notifyObservers(toggleUnit.observers, weatherDataToSend)
    }
    
    

    // private helpers
    
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
    
    // given the weatherID from the JSON; picks, loads, and displays the proper photo
    private func displayAppropriatePhoto(_ weatherID: Int) {
        let bundle = Bundle(for: type(of: self))    // we'll load images in
        let weatherLeadingDigit = weatherID / 100            // as defined by the api weatherID is a three digit number;
        weatherImageBackground.contentMode = UIView.ContentMode.scaleAspectFill // strech image to screen size
        switch weatherLeadingDigit {
        case 2 :
            //weatherImage.image = thunderstormImg
            let thunderBackground = UIImage(named: "sadman-sakib-3tc2Rfa0OPA-unsplash", in: bundle, compatibleWith: self.traitCollection)
            weatherImageBackground.image = thunderBackground
        case 3 :
            //weatherImage.image = drizzleRainImg
            let clearSkyBackground = UIImage(named: "danielle-dolson-yeN9XfiUafY-unsplash", in: bundle, compatibleWith: self.traitCollection)
            weatherImageBackground.image = clearSkyBackground
        case 5 :
            //weatherImage.image = rainDayImg
            let clearSkyBackground = UIImage(named: "nick-nice-ve-R7PCjJDk-unsplash", in: bundle, compatibleWith: self.traitCollection)
            weatherImageBackground.image = clearSkyBackground
        case 6 :
            //weatherImage.image = snowImg
            let clearSkyBackground = UIImage(named: "benjamin-parker-H3FBy3i9Q7E-unsplash", in: bundle, compatibleWith: self.traitCollection)
            weatherImageBackground.image = clearSkyBackground
        case 7 :
            //weatherImage.image = mistImg
            let clearSkyBackground = UIImage(named: "annie-spratt-7CME6Wlgrdk-unsplash", in: bundle, compatibleWith: self.traitCollection)
            weatherImageBackground.image = clearSkyBackground
        case 8 :
            if (weatherID == 800) {     // clear skies
                //weatherImage.image = clearDayImg
                let clearSkyBackground = UIImage(named: "jakob-owens-QqpQ2lU5-sE-unsplash", in: bundle, compatibleWith: self.traitCollection)
                weatherImageBackground.image = clearSkyBackground
            } else if (weatherID == 801) { // light clouds
                //weatherImage.image = fewCloudDayImg
                let clearSkyBackground = UIImage(named: "joonas-sild-CwnDbpkSdYI-unsplash", in: bundle, compatibleWith: self.traitCollection)
                weatherImageBackground.image = clearSkyBackground
            } else if (weatherID == 802) { // medium clouds
                //weatherImage.image = scatteredCloudImg
                let clearSkyBackground = UIImage(named: "daoudi-aissa-Pe1Ol9oLc4o-unsplash", in: bundle, compatibleWith: self.traitCollection)
                weatherImageBackground.image = clearSkyBackground
            } else {                // heavy clouds
                //weatherImage.image = brokenCloudImg
                let clearSkyBackground = UIImage(named: "daoudi-aissa-Pe1Ol9oLc4o-unsplash", in: bundle, compatibleWith: self.traitCollection)
                weatherImageBackground.image = clearSkyBackground
            }
        default:
            fatalError("Unexpected weather ID")
        }
    }
    
    
    // Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toDailySegue") {
            guard let weeklyController = segue.destination as? ViewControllerWeekly else {
                return;
            }
            weeklyController.toggleUnitSwitchValue = self.toggleUnit.selectedSegmentIndex
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        toggleUnit.notifyObservers(toggleUnit.observers, WeatherInfo.weatherData)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.chooseLoadingMessage()
        toggleUnit.addObserver(tempLabel)
        toggleUnit.selectedSegmentIndex = PreferencesManager.shared.currentTempUnit.rawValue
        self.weatherData = WeatherInfo.weatherData
        
        checkLocationPermissions()
        
    }

    // Location permissions
    func checkLocationPermissions() {
        if (CLLocationManager.locationServicesEnabled()) {  // does the user have access to location services
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                // Request when-in-use authorization initially
                // This is the first and the ONLY time you will be able to ask the user for permission
                locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
                break

            case .restricted, .denied:
                // Disable location features
                onLocationDisabled()
            case .authorizedWhenInUse, .authorizedAlways:
                // we can make the request as the user previously authorized location services
                locationManager.requestLocation()
                //weatherHandlerHelper()
                print("Full Access")
                break

            default:
                fatalError("Unexpected Switch case")
            }
        } else {
            // fail gracefully due to no location services
            // TODO
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        //weatherHandlerHelper()
        case .denied, .restricted:
            onLocationDisabled()
        default:
            fatalError("Unexpected authorization value")
        }
        }
    
    // Location disabled helper
    func onLocationDisabled() {
        // Sends an alert to the user asking them to enable location services
        let alert = UIAlertController(title: "Allow Location Access", message: "Weather Santiago needs access to your location. Turn on Location Services in your device settings.", preferredStyle: UIAlertController.Style.alert)
        
        // Button to Open Settings
        alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { action in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //Location successfully retrieved
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        weatherHandlerHelper(lat: locations[locations.count-1].coordinate.latitude, lon: locations[locations.count-1].coordinate.longitude)
    }
    
    //Error when retrieving location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Sends an alert to the user informint them of an error
        let alert = UIAlertController(title: "Error in retrieving action", message: "There was an error in retrieving your location. You can try again by closing the application and reopening it", preferredStyle: UIAlertController.Style.alert)
        // Button to dismiss the notice
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // Calls the function to make API req. and handles the callback
    func weatherHandlerHelper(lat: Double, lon: Double) {
        let weatherReq = WeatherRequest(PreferencesManager.shared.currentTempUnit, lat, lon)
        weatherReq.getCurrentWeather { [weak self] result in         // tell Swift garbage collection if view dismissed -> free memory
            switch result {
            case .failure(let error):
                print(error)
            case .success(let weatherCurrent):
                self?.weatherData?.currentDayData = weatherCurrent
                let currentDay = self!.weatherData?.currentDayData!
                print("%f", (currentDay?.main.temp)!)
                let tempFormattedString = String(Int((currentDay?.main.temp)!))
                let currentWeatherText: String = (currentDay?.weather[0].description)!
                guard let weatherID = currentDay?.weather[0].id else {
                    fatalError("no id for weather")
                }
                DispatchQueue.main.async {                     // UI must be changed from main thread otherwise threads contradict each other
                    self?.tempLabel.text = tempFormattedString  + "°"
                    self?.weatherLabel.text = currentWeatherText
                    self?.displayAppropriatePhoto(weatherID)           // called last as it loads all the images in
                }
            }
        }
        weatherReq.getFiveDayWeather { [weak self] result in         // tell Swift garbage collection if view dismissed -> free memory
            switch result {
            case .failure(let error):
                print(error)
            case .success(let weatherFiveDay):
                DispatchQueue.main.async {                     // Allow to switch now that we have all the data
                    self?.toggleMode.isEnabled = true
                    self?.toggleUnit.isEnabled = true
                }
                self?.weatherData?.fiveDayData = weatherFiveDay
            }
        }
        
    }

}

