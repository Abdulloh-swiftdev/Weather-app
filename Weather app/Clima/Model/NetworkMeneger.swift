//
//  NetworkMeneger.swift
//  Clima
//
//  Created by Abdulloh Bahromjonov on 11/11/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct NetworkServiceMeneger {
    
    let url = "https://api.openweathermap.org/data/2.5/weather?appid=3f01ac15545ea5842ab115df67e5f402&units=metric"
    
    
    func fetchCity(city: String)
    {
        let cityUrl = "\(url)&q=\(city)"
        performRequst(cityUrl: cityUrl)
    }
    
    
    func performRequst(cityUrl: String)
    {
        if let url = URL(string: cityUrl) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                if let safeData = data {
                    parseJSON(weatherData: safeData)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        
        do {
            let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodeData.name)
            print(decodeData.main.temp)
            let id = decodeData.weather[0].id
            print(getWeatherConditionName(weatherID: id))
        } catch {
            print(error.localizedDescription)
        }
    }
    func getWeatherConditionName(weatherID: Int) -> String {
        
        switch weatherID {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "colud.sun"
        default:
            return "cloud"
        }
    }
    
}
