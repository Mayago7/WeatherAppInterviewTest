//
//  WeatherView.swift
//  Weather-Forecast-App
//
//  Created by Bernardo Cervantes Mayagoitia on 8/30/23.
//

import SwiftUI
import CoreLocationUI

struct WeatherView: View {
    @EnvironmentObject var locationManager: LocationManager
    @StateObject var weatherManager = WeatherManager()
    @State var weather: CurrentWeatherModel
    @State var forecast: ForecastWeatherModel
    @State private var searchName: String = ""

    
    var body: some View {
        ZStack(alignment: .leading) {
            if weatherManager.isLoading {
                LoadingView()
            } else {
                VStack {
                    HStack{
                        Text("Weather App")
                            .bold().font(.title)
                            .foregroundColor(.white)
                            .font(.system(size: 70))
                            .padding()
                    }
                    .frame(maxWidth: .infinity)
                    Divider()
                    HStack {
                        Button {
                            weatherManager.isLoading = true
                            Task {
                                if let location = locationManager.location {
                                    do {
                                        self.weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                                        self.forecast = try await weatherManager.getForecastWeather(latitude: location.latitude, longitude: location.longitude)
                                    } catch ErrorTypes.invalidURL {
                                        print("Error getting weather from URL")
                                    } catch ErrorTypes.invalidHttpResponse {
                                        print("Error getting weather from HTTP response")
                                    } catch {
                                        print("Error getting weather: \(error)")
                                    }
                                }
                            }
                        } label:{

                                Image(systemName: "location.circle")
                                    .frame(minWidth: 0, maxWidth: 20, minHeight: 0, maxHeight: 15)
                                    .padding()
                                    .foregroundColor(.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color.white, lineWidth: 1)
                                    )
                            }
                            .cornerRadius(25)
                        Spacer()
                        HStack{
                            Image(systemName: "magnifyingglass")
                            TextField(" Search by city name", text: $searchName)
                                .frame(maxHeight: .infinity)
                                .onSubmit {
                                    weatherManager.isLoading = true
                                    Task {
                                        do {
                                            self.weather = try await weatherManager.getCurrentWeatherByCity(city: searchName)
                                            self.forecast = try await weatherManager.getForecastWeatherByCity(city: searchName)
                                            searchName = ""
                                        } catch ErrorTypes.invalidURL {
                                            print("Error getting weather from URL")
                                        } catch ErrorTypes.invalidHttpResponse {
                                            print("Error getting weather from HTTP response")
                                        } catch {
                                            print("Error getting weather: \(error)")
                                        }
                                    }
                                }
                        }
                        .frame(alignment: .trailing)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider()
                    
                    HStack{
                        VStack(alignment: .leading, spacing: 5) {
                            Text(weather.name)
                                .bold().font(.title)
                            Text("Today, \(Date().formatted(.dateTime.month().day()))")
                                .fontWeight(.light)
                        }
                        
                        Spacer()
                        
                        Text(weather.weather[0].main)
                            .font(.system(size: 30))
                            .fontWeight(.light)
                            .padding()
                        
                    }
                    .frame(maxWidth: .infinity)
                    HStack {
                        Text(weather.weather[0].description)
                            .font(.system(size: 20))
                            .bold()
                            .fontWeight(.light)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                        HStack(spacing: 5){
                            Text(weather.main.feelsLike.roundDouble() + "°")
                                .font(.system(size: 60))
                                .fontWeight(.bold)
                                .padding()
                            Image(systemName: GetTemperatureIcon(temp: weather.main.feelsLike.roundDouble()))
                                .font(.system(size: 40))
                        }
                        
                    }
                    Spacer()
                    Divider()

                   // Create forcast section for 5 days
                    ForEach(1..<6) { i in
                        let listIndex = i - 1
                        HStack(spacing:1) {
                            VStack(spacing: 2){
                                Text("\(getDate(addingDays: i))")
                                    .fontWeight(.light)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(forecast.list[listIndex].weather[0].description)
                                    .font(.system(size: 20))
                                    .fontWeight(.light)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            Spacer()
                            VStack(spacing: 1){
                                Text(forecast.list[listIndex].weather[0].main)
                                    .font(.system(size: 20))
                                    .fontWeight(.light)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                HStack(spacing: 1) {
                                    VStack{
                                        Text("Min: \(forecast.list[listIndex].main.tempMin.roundDouble())°")
                                            .font(.system(size: 15))
                                            .fontWeight(.bold)
                                        Text("Max: \(forecast.list[listIndex].main.tempMax.roundDouble())°")
                                            .font(.system(size: 15))
                                            .fontWeight(.bold)
                                    }
                                    Image(systemName: GetTemperatureIcon(temp: forecast.list[listIndex].main.feelsLike.roundDouble()))
                                        .font(.system(size: 20))
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                        Divider()
                    }
                    Spacer()
                    
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .ignoresSafeArea(.keyboard, edges: .bottom)
            }
            
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
        .preferredColorScheme(.dark)
    }
    
}
