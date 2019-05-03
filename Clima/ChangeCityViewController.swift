//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate {
    func userEnteredANewCityName(name : String)
}

class ChangeCityViewController: UIViewController {
    
    var delegate : ChangeCityDelegate?
    
    @IBOutlet weak var changeCityTextField: UITextField!

    // This is the IBAction that gets called when the user taps on the "Get Weather" button
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        // 1 Get the city name the user entered in the text field
        let cityName = changeCityTextField.text!
        
        // 2 If we have a delegate set, call the method userEnteredANewCityName
        delegate?.userEnteredANewCityName(name: cityName)
        
        // 3 dismiss the Change City View Controller to go back to the WeatherViewController
        dismiss(animated: true, completion: nil)
    }

    // This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
