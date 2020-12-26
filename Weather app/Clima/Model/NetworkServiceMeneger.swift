//
//  NetworkMeneger.swift
//  Clima
//
//  Created by Abdulloh Bahromjonov on 11/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

protocol NetworkServiceMenegerDelegate {
    func didUpdateWeather(weahter: WeatherModel)
}

struct WeatherService
{
    
    let url = "https://api.openweathermap.org/data/2.5/weather?appid=3f01ac15545ea5842ab115df67e5f402&units=metric"
    
    var delegate: NetworkServiceMenegerDelegate?
    
    func fetchCity(city: String)
    {
        let cityUrl = "\(url)&q=\(city)"
        performRequst(cityUrl: cityUrl)
    }
    
    
    func performRequst(cityUrl: String)
    {
        if let url = URL(string: cityUrl)
        {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url)
            { (data, response, error) in
                if error != nil
                {
                    print(error!.localizedDescription)
                    return
                }
                if let safeData = data
                {
                    if let weather = parseJSON(weatherData: safeData)
                    {
                        self.delegate?.didUpdateWeather(weahter: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel?
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
            print(error.localizedDescription)
            return nil
        }
    }
    
    
}
