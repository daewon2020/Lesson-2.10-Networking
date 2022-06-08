//
//  DataManager.swift
//  Lesson 2.10
//
//  Created by Kostya on 04.04.2022.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    
    let keyAPI = ["X-Yandex-API-Key": "7a39c9aa-d4d7-4c79-be43-2b668b05a140"]
    let urlWeather = "https://api.weather.yandex.ru/v2/forecast"
    let urlWeatherParameters = [
        URLQueryItem(name: "lat", value: "57.626560"),
        URLQueryItem(name: "lon", value: "39.893806"),
        URLQueryItem(name: "lang", value: "ru_RU"),
        URLQueryItem(name: "limit", value: "7"),
        URLQueryItem(name: "hours", value: "false"),
        URLQueryItem(name: "extra", value: "true"),
    ]
    private init () {}
}
