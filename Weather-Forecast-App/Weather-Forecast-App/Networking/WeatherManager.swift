//
//  WeatherManager.swift
//  Weather-Forecast-App
//
//  Created by Bernardo Cervantes Mayagoitia on 8/30/23.
//

import Foundation
import CoreLocation

enum ErrorTypes: Error {
    case invalidURL
    case invalidHttpResponse
}

class WeatherManager: ObservableObject {
    @Published var isLoading = false
    
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> CurrentWeatherModel {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=95ea6662bd23d8eaaf85f1670797d3f4&units=imperial") else {
            DispatchQueue.main.async {
                self.isLoading = false
            }
            throw ErrorTypes.invalidURL
        }
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            DispatchQueue.main.async {
                self.isLoading = false
            }
            throw ErrorTypes.invalidHttpResponse
        }
        
        let decodedData = try JSONDecoder().decode(CurrentWeatherModel.self, from: data)
        
        DispatchQueue.main.async {
            self.isLoading = false
        }
        return decodedData
    }
    
    func getForecastWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ForecastWeatherModel {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=95ea6662bd23d8eaaf85f1670797d3f4&units=imperial&cnt=5") else {
            DispatchQueue.main.async {
                self.isLoading = false
            }
            throw ErrorTypes.invalidURL
        }
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            DispatchQueue.main.async {
                self.isLoading = false
            }
            throw ErrorTypes.invalidHttpResponse
        }
        
        let decodedData = try JSONDecoder().decode(ForecastWeatherModel.self, from: data)
        
        DispatchQueue.main.async {
            self.isLoading = false
        }
        return decodedData
    }
    
    func getCurrentWeatherByCity(city: String) async throws -> CurrentWeatherModel {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?appid=95ea6662bd23d8eaaf85f1670797d3f4&units=imperial&q=\(city)") else {
            DispatchQueue.main.async {
                self.isLoading = false
            }
            throw ErrorTypes.invalidURL
        }
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            DispatchQueue.main.async {
                self.isLoading = false
            }
            throw ErrorTypes.invalidHttpResponse
        }
        
        let decodedData = try JSONDecoder().decode(CurrentWeatherModel.self, from: data)
        
        DispatchQueue.main.async {
            self.isLoading = false
        }
        return decodedData
    }
    
    func getForecastWeatherByCity(city: String) async throws -> ForecastWeatherModel {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=95ea6662bd23d8eaaf85f1670797d3f4&units=imperial&cnt=5") else {
            DispatchQueue.main.async {
                self.isLoading = false
            }
            throw ErrorTypes.invalidURL
        }
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            DispatchQueue.main.async {
                self.isLoading = false
            }
            throw ErrorTypes.invalidHttpResponse
        }
        
        let decodedData = try JSONDecoder().decode(ForecastWeatherModel.self, from: data)
        
        DispatchQueue.main.async {
            self.isLoading = false
        }
        return decodedData
    }
}
