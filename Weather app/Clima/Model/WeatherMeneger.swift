//
//  NetworkMeneger.swift
//  Clima
//
//  Created by Abdulloh Bahromjonov on 11/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherMengerDelegate
{
    func didUpdateWeather(_ weatherMeneger: WeatherMeneger, weahter: WeatherModel)
    func didFailWithError(error: Error)
}


struct WeatherMeneger
{
    
    let url = "https://api.openweathermap.org/data/2.5/weather?appid=3f01ac15545ea5842ab115df67e5f402&units=metric"
    
    var delegate: WeatherMengerDelegate?
    
    func fetchCity(city: String)
    {
        let cityUrl = "\(url)&q=\(city)"
        performRequst(cityUrl)
    }
    func fetchLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    {
        let locationUrl = "\(url)&lat=\(latitude)&lon=\(longitude)"
        performRequst(locationUrl)
    }
    
    
    func performRequst(_ cityUrl: String)
    {
        if let url = URL(string: cityUrl)
        {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error
                    {
                        self.delegate?.didFailWithError(error: error.localizedDescription as! Error)
                        return
                    }
                    if let safeData = data
                    {
                        if let weather = parseJSON(safeData)
                        {
                            print(weather.conditionName)
                            self.delegate?.didUpdateWeather(self, weahter: weather)
                        }
                    }
                }
                
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?
    {
        let decoder = JSONDecoder()
        
        do
        {
            let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodeData.weather[0].id
            let temp = decodeData.main.temp
            let name = decodeData.name
            
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp)
            
            return weather
            
        } catch
        {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}
