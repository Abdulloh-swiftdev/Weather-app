//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherMeneger = WeatherMeneger()
    let locationMeneger = CLLocationManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        locationMeneger.delegate = self
        locationMeneger.requestWhenInUseAuthorization()
        locationMeneger.requestLocation()
        
        weatherMeneger.delegate = self
        searchTextField.delegate = self
    }
    
    @IBAction func locationBtnWasPressed(_ sender: Any)
    {
        locationMeneger.requestLocation()
    }
    
    
}



//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate
{
    @IBAction func searchBtnWasPressed(_ sender: Any)
    {
        searchTextField.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        searchTextField.endEditing(true)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if let city = searchTextField.text {
            weatherMeneger.fetchCity(city: city)
        }
        searchTextField.text = ""
    }
}

//MARK: - WeatherMenegerDelegate

extension WeatherViewController: WeatherMengerDelegate
{
    func didUpdateWeather(_ weatherMeneger: WeatherMeneger, weahter: WeatherModel)
    {
            self.temperatureLabel.text = weahter.temperatureString
            self.conditionImageView.image = UIImage(systemName: weahter.conditionName)
            self.cityLabel.text = weahter.cityName
            
    }
    func didFailWithError(error: Error)
    {
        
            self.cityLabel.text = error.localizedDescription
        
    }
}


extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last{
            locationMeneger.stopUpdatingLocation()
            let lon = location.coordinate.longitude
            let lat = location.coordinate.latitude
            weatherMeneger.fetchLocation(latitude: lat, longitude: lon)
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        cityLabel.text = "Invalid location"
        temperatureLabel.text = "0"
        conditionImageView.image = UIImage(systemName: "questionmark")
    }
}
