//
//  NetworkManager.swift
//  Lesson 2.10
//
//  Created by Kostya on 03.04.2022.
//

import UIKit

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    static let shared = NetworkManager()
    
    typealias Handler = (Result<YandexWeather, NetworkError>) -> Void
    
    private init() {}
    
    func fetchWeather(completion: @escaping Handler)  {
        let urlWeather = DataManager.shared.urlWeather
        let urlWeatherParameters = DataManager.shared.urlWeatherParameters
        let keyAPI = DataManager.shared.keyAPI
        
        guard var urlComponents = URLComponents(string: urlWeather) else { return }
        urlComponents.queryItems = urlWeatherParameters
        
        guard let url = urlComponents.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(keyAPI.first?.value ?? "", forHTTPHeaderField: keyAPI.first?.key ?? "")
        
        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let yandexWeather = try JSONDecoder().decode(YandexWeather.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(yandexWeather))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
