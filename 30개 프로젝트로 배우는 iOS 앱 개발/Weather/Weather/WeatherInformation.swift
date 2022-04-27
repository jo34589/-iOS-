//
//  WeatherInformation.swift
//  Weather
//
//  Created by 엔나루 on 2022/03/20.
//

import Foundation

//json decoding, encodidng 을 위해 채택한 프로토콜
struct WeatherInformation: Codable {
    let weather: [Weather]
    let temp: Temp
    let name: String
    
    enum codingKeys: String, CodingKey {
        case weather
        case temp = "main"
        case name
    }
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Temp: Codable {
    let temp: Double
    let feelsLike: Double
    let minTemp: Double
    let maxTemp: Double
    
    //json 키와 이름을 다르게 쓰고 싶을 때 사용하는 것
    enum codingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
    }
}
