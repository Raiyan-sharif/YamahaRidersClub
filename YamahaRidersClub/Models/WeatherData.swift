//
//  WeatherData.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 19/3/21.
//

import Foundation
import UIKit

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}


// MARK: - Main
struct Main: Codable {
    let temp: Double
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
}

