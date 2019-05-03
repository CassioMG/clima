//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "3502a546ae5db5677a347ac655a2f26d"
    /***Get your own App ID at https://openweathermap.org/appid ****/
    
    
    // Instance variables
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    // IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - Networking
    func getWeatherData (url: String, parameters: [String : String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            
            if response.result.isSuccess {
                let weatherData : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherData)
                
            } else {
                print("Error: \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
                
            }
        }
    }
    
    
    // MARK: - JSON Parsing
    func updateWeatherData (json : JSON) {
        
        print("WEATHER DATA: \(json)")
        
        if let tempResult = json["main"]["temp"].double {
            
            weatherDataModel.temperature = Int(tempResult - 273.15)
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            updateUIWithWeatherData()
            
        } else {
            
            if let message = json["message"].string {
                cityLabel.text = message.capitalized
                
            } else {
                cityLabel.text = "Weather Unavailable"
            }
        }
    }


    // MARK: - UI Updates
    func updateUIWithWeatherData () {
        
        temperatureLabel.text = "\(weatherDataModel.temperature)℃"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        cityLabel.text = weatherDataModel.city
    }
    
    // MARK: - Location Manager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last!
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            let params = ["lon" : longitude, "lat" : latitude, "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("DID FAIL WITH ERROR: ", error)
        cityLabel.text = "Location Unavailable"
    }
    
    // MARK: - Change City Delegate
    func userEnteredANewCityName(name: String) {
        
        let params = ["q" : name, "appid" : APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }

    // MARK: - Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "changeCityName" {
            
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate = self
        }
    }
 
    
}
