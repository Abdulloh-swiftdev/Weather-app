//
//  WeatherData.swift
//  Clima
//
//  Created by Abdulloh Bahromjonov on 11/13/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    var weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    
}
struct Weather: Codable {
    let id: Int
}
